# LetterMusic

**LetterMusic** é um aplicativo móvel voltado à avaliação de músicas, permitindo que usuários pesquisem faixas, visualizem detalhes, atribuam notas, deixem comentários, salvem músicas favoritas e acompanhem rankings e histórico de avaliações.

---

## Índice

- [Sobre o projeto](#sobre-o-projeto)
- [Pré-requisitos](#pré-requisitos)
- [Instalação](#instalação)
- [Uso](#uso)
- [Funcionalidades principais](#funcionalidades-principais)
- [Contribuição](#contribuição)

---

## Sobre o projeto

O **LetterMusic** foi desenvolvido para oferecer uma experiência mais interativa com a música, indo além da simples reprodução de faixas. O aplicativo permite que usuários expressem opiniões, registrem avaliações e acompanhem percepções de outras pessoas sobre músicas e álbuns.

O projeto é focado em:
- avaliação musical organizada;
- interação por meio de comentários e favoritos;
- consulta a informações de músicas e álbuns;
- visualização de histórico e rankings.

---

## Pré-requisitos

Antes de executar o projeto, verifique se você possui:

- **Flutter** instalado;
- **Dart** configurado;
- **Git** para clonagem do repositório;
- **Android Studio** ou outro ambiente compatível com emulador/dispositivo Android;
- conexão com a internet;
- configuração do **Firebase / Cloud Firestore** para acesso aos dados.

### Verificação das versões

```bash
flutter --version
dart --version
git --version
```

---

## Instalação

### 1. Clone o repositório

```bash
git clone https://github.com/vitoroli22/Letter-Music.git
cd Letter-Music
```

### 2. Instale as dependências

```bash
flutter pub get
```

### 3. Configure o Firebase

Certifique-se de que o projeto esteja conectado ao Firebase e que os arquivos de configuração necessários estejam presentes no ambiente da aplicação.

- Adicione as credenciais do Firebase conforme a estrutura do projeto;
- Verifique a configuração do **Cloud Firestore**;
- Confirme se as permissões de acesso estão corretas.

### 4. Execute o aplicativo

```bash
flutter run
```

---

## Uso

Após iniciar o aplicativo, o usuário pode:

- criar uma conta;
- fazer login;
- pesquisar músicas por nome ou artista;
- abrir a tela de detalhes de uma música;
- avaliar músicas com notas;
- comentar sobre avaliações;
- favoritar músicas para avaliar depois;
- editar dados de perfil;
- consultar histórico de avaliações;
- visualizar rankings de músicas e álbuns.

### Exemplo de fluxo de uso

1. O usuário realiza login no sistema.
2. Busca por uma música ou artista.
3. Seleciona um resultado da lista.
4. Visualiza os detalhes da obra.
5. Registra uma avaliação e, se desejar, um comentário.
6. Favorita a música para acesso futuro.
7. Acompanha seu histórico e suas interações no perfil.

---

## Funcionalidades principais

- **Cadastro de usuário**
  - criação de conta com nome de usuário, e-mail, senha e foto de perfil;

- **Autenticação**
  - login com e-mail e senha cadastrados;

- **Pesquisa musical**
  - busca por música ou álbum;

- **Detalhes da música**
  - exibição de informações da obra, nota geral e ações disponíveis;

- **Avaliação**
  - notas de **0,5 a 5,0 estrelas**, com incrementos de **0,5**;

- **Comentários**
  - registro de comentários vinculados à avaliação do usuário;

- **Favoritos**
  - salvamento de músicas para avaliação posterior;

- **Histórico**
  - exibição das músicas já avaliadas pelo usuário;

- **Ranking**
  - listagem das músicas e álbuns mais avaliados;

- **Perfil**
  - edição de dados pessoais e acesso às músicas favoritas;

---

## Estrutura do projeto

A organização do projeto segue uma proposta de desenvolvimento mobile com foco em:
- frontend em **Flutter**;
- persistência e consulta de dados no **Cloud Firestore**;
- documentação e modelagem com apoio de diagramas UML;
- prototipação das telas em ferramenta de design.

Os diagramas e fluxos do sistema podem ser mantidos na pasta de documentação do repositório. Para criação de diagramas, pode-se utilizar o **draw.io**, uma ferramenta online gratuita para diagramas.

---

## Contribuição

Contribuições são bem-vindas. Para colaborar:

1. Faça um fork do repositório.
2. Crie uma branch para sua alteração:

```bash
git checkout -b feat/minha-alteracao
```

3. Implemente a melhoria ou correção.
4. Verifique se o código segue o padrão do projeto.
5. Execute os testes disponíveis.
6. Envie um pull request com uma descrição clara das mudanças.

### Diretrizes para colaboradores

- mantenha o foco em uma única melhoria por pull request;
- siga o padrão de organização do código já adotado;
- evite mudanças não relacionadas ao objetivo do PR;
- atualize a documentação quando necessário;
- teste as alterações antes de enviar.

### Sugestões de boas práticas

- use nomes claros para variáveis, funções e arquivos;
- preserve consistência visual e estrutural;
- documente decisões importantes;
- revise os impactos em telas, navegação e integração com dados.

---

## Licença

Este projeto deve informar a licença oficial adotada pelo repositório.

**MIT License** — uso, modificação e distribuição permitidos com manutenção dos créditos.

---
