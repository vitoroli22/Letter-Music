import 'dart:convert';
import 'package:http/http.dart' as http;

class SpotifyService {
  final String clientId = '3e1d39d5e6fd400ab48878db625b3cbc';       // Seu Client ID
  final String clientSecret = '11284b2d484e4e4499a1f361536879e9';   // Seu Client Secret

  // Função para pegar o access token
  Future<String> getAccessToken() async {
    final url = Uri.parse('https://accounts.spotify.com/api/token');

    final credentials = base64.encode(utf8.encode('$clientId:$clientSecret'));

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Basic $credentials',
        'Content-Type': 'application/x-www-form-urlencoded'
      },
      body: {
        'grant_type': 'client_credentials'
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['access_token']; // token válido por 1 hora
    } else {
      throw Exception('Falha ao obter access token: ${response.body}');
    }
  }

  // Função para pesquisar músicas no Spotify
  Future<List<Map<String, dynamic>>> searchTracks(String query) async {
    final token = await getAccessToken(); // pega o access token
    final url = Uri.parse('https://api.spotify.com/v1/search?q=$query&type=track&limit=10');

    final response = await http.get(url, headers: {
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final tracks = data['tracks']['items'] as List;

      return tracks.map((track) {
        return {
          'title': track['name'],
          'artist': track['artists'][0]['name'],
          'album': track['album']['name'],
          'image': track['album']['images'][0]['url'], // capa maior
        };
      }).toList();
    } else {
      throw Exception('Falha ao buscar músicas: ${response.body}');
    }
  }

  // Função para pesquisar álbuns no Spotify (AJUSTADA: agora captura e retorna o 'id' do álbum)
  Future<List<Map<String, dynamic>>> searchAlbums(String query) async {
    final token = await getAccessToken(); // pega o access token
    final url = Uri.parse('https://api.spotify.com/v1/search?q=${Uri.encodeComponent(query)}&type=album&limit=10');

    final response = await http.get(url, headers: {
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final albums = data['albums']['items'] as List;

      return albums.map((album) {
        return {
          'id': album['id'], // ID essencial para buscar as faixas posteriormente
          'title': album['name'],
          'artist': album['artists'][0]['name'],
          'image': album['images'].isNotEmpty ? album['images'][0]['url'] : '', // pega a capa do álbum
        };
      }).toList();
    } else {
      throw Exception('Falha ao buscar álbuns: ${response.body}');
    }
  }

  // NOVA FUNÇÃO: Busca todas as faixas pertencentes a um álbum usando o ID dele
  Future<List<Map<String, dynamic>>> getAlbumTracks(String albumId) async {
    final token = await getAccessToken();
    final url = Uri.parse('https://api.spotify.com/v1/albums/$albumId/tracks?limit=20');

    final response = await http.get(url, headers: {
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final tracks = data['items'] as List;

      return tracks.map((track) {
        return {
          'title': track['name'],
          'artist': track['artists'][0]['name'],
        };
      }).toList();
    } else {
      throw Exception('Falha ao obter faixas do álbum: ${response.body}');
    }
  }

  // Função para obter detalhes de uma música específica
  Future<Map<String, dynamic>> getTrackDetails(String trackName) async {
    final token = await getAccessToken();
    final url = Uri.parse(
        'https://api.spotify.com/v1/search?q=${Uri.encodeComponent(trackName)}&type=track&limit=1');

    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['tracks']['items'].isNotEmpty) {
        final track = data['tracks']['items'][0];
        return {
          'title': track['name'],
          'artist': track['artists'][0]['name'],
          'album': track['album']['name'],
          'imageUrl': track['album']['images'][0]['url'],
        };
      }
    }

    // Retorna dados básicos se não encontrar nada
    return {
      'title': trackName,
      'artist': 'Desconhecido',
      'album': 'Desconhecido',
      'imageUrl': '',
    };
  }
}