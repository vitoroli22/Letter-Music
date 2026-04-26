# PLANO DE TRABALHO

| Nome do Projeto:       | LetterMusic |
| ---------------------- | --------------------------------- |
| Versão:                | 1.8                               |
| Status:                | Front end                         |
| Executor Principal:    | João Vitor Oliveira Simões        |
| Coordenador Principal: | Walter Jonas de Sousa Viana       |

---

# HISTÓRICO DE VERSÕES
| Versão | Responsável                                  | Data                  | Alteração |
| ------ | -------------------------------------------- | --------------------- | ---------- |
| 1.0    | Chyntia Freitas, João Vitor e Manoele Braga. | 25/03/2026            | Definição inicial da proposta do projeto.      |
| 1.1    | João Vitor Oliveira                          | 30/03/2026            | Elaboração dos requisitos funcionais, não funcionais e regras de negócios.  |
| 1.2    | Lais Samily                                  | 30/03/2026            | Diagrama de Sequência             |
| 1.3    | Manoele Braga                                | 01/04/2026            | Diagrama de caso de uso           |
| 1.4    | Tiago Santos                                 | 01/04/2026            | Diagrama de Classe                |
| 1.5    | João Vitor Oliveira                          | 03/04/2026            | Diagrama de Atividade             |
| 1.6    | Chyntia Freitas                              | 04/04/2026            | Prototipação das Telas            |
| 1.7    | Lais Samily                                  | 04/04/2026            | Diagrama de Objetos               |
| 1.8    | Chyntia Freitas                              | 05/04/2026            | Arquitetura do sistema            |


---

## Ficha Técnica
## Equipe Responsável pela Elaboração
- Desenvolvedor 1 | Chyntia Freitas Prestes
- Desenvolvedor 2 | João Vitor Oliveira Simões
- Desenvolvedor 3 | Julia de Souza Farias
- Desenvolvedor 4 | Laís Samilly Xavier da Silva
- Desenvolvedor 5 | Manoele Braga Colares da Costa
- Desenvolvedor 6 | Tiago dos Santos Mendonça

## Público Alvo 
&nbsp;&nbsp;&nbsp;&nbsp;O público-alvo do aplicativo LetterMusic é composto principalmente por jovens e adultos que possuem interesse ativo em música e no hábito de avaliar, comentar e compartilhar opiniões sobre obras musicais.
Enquadram-se nesse perfil usuários que não desejam apenas ouvir músicas em plataformas de streaming, mas também analisar faixas de forma mais detalhada, considerando aspectos como letra, produção, composição, impacto cultural e qualidade musical.

Também fazem parte desse público pessoas que acompanham lançamentos, constroem playlists com frequência, seguem artistas e álbuns específicos e valorizam experiências digitais voltadas à expressão de opinião e à interação com avaliações de outros usuários.
Além disso, o aplicativo pode atrair estudantes, criadores de conteúdo, fãs de crítica musical e usuários que gostam de registrar suas percepções sobre músicas de maneira organizada e comparativa.
Por se tratar de uma proposta centrada em avaliação musical, o aplicativo é especialmente direcionado a usuários que buscam uma relação mais participativa e reflexiva com a música, indo além do consumo passivo e valorizando a análise individual de diferentes critérios de cada obra.

# 1. INTRODUÇÃO
&nbsp;&nbsp;&nbsp;&nbsp;A música está presente de forma constante na vida das pessoas, acompanhando diferentes momentos, rotinas e experiências do cotidiano. Mais do que uma forma de entretenimento, ela também exerce influência sobre emoções, memórias e estados de espírito, podendo transmitir sensações como alegria, nostalgia, motivação, tranquilidade e até identificação pessoal com determinadas letras, ritmos e contextos. 
Em muitos casos, a relação do indivíduo com uma música vai além do simples ato de escutar, envolvendo interpretações, preferências e julgamentos construídos a partir da vivência de cada ouvinte. 

Nesse cenário, observa-se que o consumo musical tem se tornado cada vez mais frequente nas plataformas digitais, mas nem sempre esses espaços oferecem ao usuário a possibilidade de expressar sua percepção de maneira mais detalhada e reflexiva.
Muitas vezes, a experiência fica restrita à reprodução da música, sem abrir espaço para uma análise mais crítica sobre os elementos que compõem aquela obra e sobre o impacto que ela causa em quem a escuta. 

Diante disso, o sistema proposto surge com a finalidade de oferecer aos usuários um ambiente voltado à avaliação musical, no qual seja possível registrar opiniões e percepções sobre diferentes músicas de forma organizada e interativa.
A proposta busca proporcionar uma experiência em que o usuário não apenas tenha contato com informações sobre as obras musicais, mas também possa registrar sua opinião sobre aquilo que escuta, visualizar diferentes percepções de outros usuários e participar de um espaço voltado à avaliação musical. 
Dessa forma, o aplicativo se propõe a atender pessoas que desejam ter uma experiência mais interativa com a música, não se limitando apenas à escuta, mas também à reflexão e à expressão de suas impressões sobre cada obra.

## 1.1. Estrutura/Visão Geral do Documento
&nbsp;&nbsp;&nbsp;&nbsp;Este documento apresenta a especificação do sistema LetterMusic, reunindo de forma organizada as informações necessárias para a compreensão da proposta, da estrutura e do funcionamento do aplicativo.
Sua organização foi definida com o objetivo de facilitar a leitura e permitir uma visão clara dos principais elementos que compõem o projeto. As demais seções apresentam a especificação do sistema LetterMusic e estão organizadas como descrito abaixo:
- **Seção 1 – Introdução** apresenta a contextualização do projeto e os elementos iniciais necessários para a compreensão do documento. Essa seção é composta pelas subseções **1.1** Estrutura/Visão Geral do Documento, **1.2** Audiência do Documento, **1.3** Convenções, Termos e Abreviações, **1.4** Descrição Geral do Sistema e **1.5** Descrição dos Usuários.

- **Seção 2 – Requisitos Gerais do Sistema** reúne os requisitos que orientam o funcionamento da aplicação. Essa seção está subdividida em **2.1** Requisitos Funcionais, **2.2** Requisitos Não-Funcionais e **2.3** Regras de Negócio, contemplando as funcionalidades do sistema, suas características de qualidade e as restrições de funcionamento.

- **Seção 3 – Diagramas UML** apresenta os artefatos de modelagem elaborados para representar o sistema de forma visual e estruturada. Essa seção contém as subseções **3.1** Diagramas de Casos de Uso, **3.2** Especificação de Casos de Uso, **3.3** Diagrama de Sequência, **3.4** Diagrama de Atividades, **3.5** Diagrama de Classes e **3.6** Diagrama de Objetos.

- **Seção 4 – Arquitetura do Sistema** descreve a organização estrutural da aplicação, apresentando a visão geral da solução e os aspectos arquiteturais adotados no desenvolvimento do projeto.

- **Seção 5 – Padrões de Projeto** apresenta os padrões utilizados como apoio à organização e à estruturação do sistema.
  
- **Seção 6 – Prototipação das Telas** reúne as interfaces planejadas para o aplicativo, permitindo visualizar a disposição dos elementos e a forma de interação do usuário com a aplicação.

- **Seção 7 – Metodologia de Projeto** apresenta a organização do desenvolvimento do sistema. Essa seção está dividida em **6.1** Estrutura do Projeto, **6.2** Ambiente de Desenvolvimento e **6.3** Cronograma, contemplando a organização da equipe, as tecnologias utilizadas e o planejamento das etapas do projeto.

- **Seção 8 – Análise de Risco** aborda os possíveis riscos associados ao desenvolvimento do aplicativo, considerando fatores que podem impactar a execução e a qualidade do sistema.
  
- **Seção 9 – Apêndice** reúne materiais complementares relacionados ao projeto, que auxiliam na documentação e no registro das atividades desenvolvidas.

## 1.2. Audiência do Documento
Este documento é destinado às pessoas envolvidas no desenvolvimento, acompanhamento e avaliação do sistema LetterMusic, servindo como referência para compreensão da proposta, da modelagem, da estrutura e das funcionalidades previstas para a aplicação. A seguir, apresenta-se a audiência deste documento.
### Tabela 1 – Audiência do Documento
| Público                      | Descrição                         | 
| ---------------------------- | --------------------------------- |
| Equipe de desenvolvimento    | Utiliza o documento como base para compreender os requisitos, a estrutura, os diagramas e as decisões adotadas no projeto. |
| Professor da disciplina      | Utiliza o documento para acompanhar e avaliar a organização, a modelagem e o desenvolvimento do sistema proposto.          |
| Integrantes do grupo         | Consultam o documento para alinhar as atividades, compreender o escopo do projeto e acompanhar a evolução das etapas desenvolvidas.  |
| Futuros mantenedores         | Podem utilizar o documento para entender a estrutura do sistema e facilitar futuras correções, melhorias ou expansões da aplicação.      |

## 1.3. Convenções, Termos e Abreviações
Para facilitar a compreensão do documento, apresentam-se as siglas utilizadas na especificação dos requisitos e a classificação adotada para definição de prioridade.
### Tabela 2 – Abreviações
| Sigla                        | Significado                       |
| ---------------------------- | --------------------------------- |
| RF                           | Requisito Funcional               |
| RNF                          | Requisito Não Funcional           |
| RN                           | Regra de Negócios                 |

### Tabela 3 – Classificação de prioridade
| Termo                        | Significado                       |
| ---------------------------- | --------------------------------- |
| Essencial                    | Requisito indispensável para o funcionamento do sistema.           |
| Importante                   | Requisito indispensável para o funcionamento do sistema.           |
| Desejável                    | Requisito relevante para o sistema, mas que não compromete totalmente seu funcionamento caso não seja implementado na primeira versão                         |

## 1.4. Descrição Geral do Sistema
- O sistema proposto, denominado LetterMusic, consiste em um aplicativo móvel voltado à avaliação de músicas, desenvolvido com a finalidade de proporcionar aos usuários um ambiente digital para registrar, consultar e acompanhar opiniões sobre obras musicais. A proposta do sistema está centrada na interação do usuário com a música por meio da atribuição de notas, comentários e marcação de músicas favoritas para avaliação posterior.

- Diferente de plataformas cujo foco principal está apenas na reprodução musical, o LetterMusic busca oferecer uma experiência voltada à análise e à expressão de percepções individuais, permitindo que os usuários tenham acesso a informações sobre músicas e participem de uma dinâmica de avaliação mais ativa e organizada. Além disso, o sistema contribui para que os usuários acompanhem avaliações gerais, interajam com as obras de forma mais reflexiva e mantenham um histórico de suas experiências dentro da plataforma.

## 1.5. Descrição dos Usuários
Os usuários deste sistema podem ser classificados da seguinte forma:
**1. Usuário:** são pessoas interessadas em música e em registrar suas percepções sobre diferentes obras musicais por meio do aplicativo. Esses usuários utilizam o sistema para pesquisar músicas, visualizar informações, atribuir avaliações, comentar e favoritar obras para interação posterior. De modo geral, trata-se de um público familiarizado com dispositivos móveis e com o uso de plataformas digitais.

# 2. Requisitos Gerais do Sistema
## 2.1 Requisitos Funcionais
### Tabela 4 - Requisitos Funcionais
| ID                             | Descrição         | Prioridade                                                                            |
| ------------------------------ | ----------------- | ------------------------------------------------------------------------------------- |
| RF001  | O sistema deve permitir que o usuário crie uma conta.         | Essencial  |
| RF002  | O sistema deve permitir que o usuário realize login.          | Essencial  |
| RF003  | O sistema deve permitir que o usuário pesquise músicas.       | Essencial  |
| RF004  | O sistema deve exibir os resultados da pesquisa e permitir que o usuário selecione uma música para visualizar seus detalhes. | Essencial   |
| RF005  | O sistema deve exibir, na tela de detalhes da música, informações da obra, sua nota geral e as opções de interação disponíveis ao usuário. | Essencial|
| RF006  | O sistema deve permitir que o usuário avalie músicas.     | Essencial                               |
| RF007  | O sistema deve permitir que o usuário registre um comentário associado à sua avaliação de uma música. | Importante       |
| RF008  | O sistema deve calcular automaticamente a nota geral de um álbum com base nas notas gerais das músicas que o compõem. | Essencial       |
| RF009  | O sistema deve exibir um ranking com as 10 músicas mais avaliadas.                                  | Desejável                                 |
| RF010  | O sistema deve exibir um ranking com os 10 álbuns mais avaliados.                                   | Desejável                                |
| RF011  | O sistema deve exibir um histórico das músicas avaliadas pelo usuário.                              | Essencial                                |
| RF012  | O sistema deve permitir que o usuário favorite músicas para avaliá-las posteriormente               | Desejável                                |
| RF013  | O sistema deve permitir que o usuário edite seus dados de perfil.                                   |    Essencial                             |
| RF014  | O sistema deve exibir, na área de perfil do usuário, as opções de edição de perfil e o acesso às músicas favoritas.  | Essencial            |
| RF015  | O sistema deve permitir que o usuário compartilhe no Instagram informações sobre músicas ou álbuns avaliados.        |  Desejável            |

## 2.2. Requisitos Não-Funcionais
### Tabela 5 - Requisitos Não-Funcionais
| ID                             | Descrição         | Categoria   | Prioridade |
| ------------------------------ | ----------------- | ----------------------------------------- | ------------- |
| RNF001  | O sistema deve ser compatível com dispositivos móveis Android.         | Compatibilidade  |Essencial   |
| RNF002  | O sistema deve possuir interface responsiva e adaptável a diferentes tamanhos de tela.   | Usabilidade  | Essencial        |
| RNF003  | O sistema deve garantir a confidencialidade dos dados cadastrados dos usuários.       | Segurança  | Essencial  |
| RNF004  | O sistema deve garantir a integridade das avaliações, comentários, favoritos e dados de perfil armazenados.     | Confiabilidade   | Essencial|
| RNF005  | O sistema deve apresentar interface com navegação intuitiva e padronizada.         | Usabilidade| Essencial           |
| RNF006  | O sistema deve emitir mensagens de erro claras e compreensíveis ao usuário.     | Usabilidade   | Importante  |
| RNF007  | O sistema deve depender de conexão com a internet para consultar dados musicais provenientes da API externa.      | Dependência Externa | Essencial|
| RNF008  | O sistema deve manter consistência visual em todas as telas da aplicação.      | Usabilidade  | Importante    |

## 2.3. Regras de Negócio
### Tabela 6 - Regras de Negócio
| ID     | Descrição                                                     | Requisitos Relacionados  |
| ------ | ------------------------------------------------------------- | ------------------------ |
| RN001  | No cadastro, o usuário deve informar nome de usuário, e-mail, senha e foto de perfil.| RF001    |
| RN002  | O nome de usuário e o e-mail devem ser únicos no sistema. | RF001, RF013 |
| RN003  | A senha deve conter no mínimo 6 caracteres, incluindo pelo menos uma letra, um número e um caractere especial. | RF001, RF013    |
| RN004  | Em caso de nome de usuário ou e-mail já cadastrado, o sistema deve informar a indisponibilidade ao usuário. | RF001, RF013       |
| RN005  | O login deve ser realizado com e-mail e senha previamente cadastrados no sistema. | RF002        |
| RN006  | A pesquisa de músicas deve permitir busca pelo nome da música ou pelo nome do artista/cantor, e os resultados exibidos devem corresponder ao termo informado pelo usuário. | RF003, RF004    |
| RN007  | Na tela de detalhes da música, devem ser exibidas informações da obra, a nota geral calculada e as opções de avaliar, comentar e favoritar. | RF005  |
| RN008  | A avaliação da música deve variar de 0,5 a 5,0 estrelas, com incrementos de 0,5 estrelas, e cada usuário pode registrar apenas uma avaliação por música, podendo editá-la posteriormente. | RF006    |
| RN009  | Cada usuário pode registrar apenas um comentário por música avaliada, e esse comentário deve estar vinculado à avaliação realizada. | RF007     |
| RN010  | A nota geral de cada música deve ser calculada com base na média das avaliações registradas por todos os usuários. | RF005, RF006      |
| RN011  | A nota geral do álbum deve ser calculada com base na média das notas gerais das músicas que o compõem, considerando avaliações de 0,5 a 5,0 estrelas em intervalos de 0,5.| RF008           |
| RN012  | O ranking de músicas deve exibir apenas as 10 músicas com maior quantidade de avaliações registradas. | RF009        |
| RN013  | O ranking de álbuns deve exibir apenas os 10 álbuns com maior quantidade de avaliações registradas.    | RF010         |
| RN014  | O histórico de avaliações deve ser exibido em ordem da avaliação mais recente para a mais antiga.      | RF011          |
| RN015  | O usuário pode favoritar músicas para acessá-las posteriormente e avaliá-las quando desejar.        | RF012          |
| RN016  | A edição de perfil deve permitir alterar nome de usuário, senha e foto de perfil, obedecendo aos mesmos critérios definidos no cadastro. | RF013      |
| RN017  | A área de perfil deve exibir as opções de edição de perfil e permitir o acesso às músicas favoritas pelo usuário.  | RF014           |
| RN018  | O compartilhamento deve ocorrer a partir de conteúdos já existentes no sistema, relacionados a músicas ou álbuns avaliados. | RF015           |

# 3. Padrões de Projeto
- No desenvolvimento do sistema LetterMusic, foram considerados os padrões de projeto Singleton e Observer, por se mostrarem adequados às necessidades da aplicação e contribuírem para uma estrutura de software mais organizada, reutilizável e de fácil manutenção. De acordo com o material da disciplina, os padrões de projeto correspondem a soluções reutilizáveis para problemas recorrentes de design de software, auxiliando na clareza do sistema, na redução de acoplamento e na melhoria da comunicação entre desenvolvedores.

- O padrão **Singleton** pode ser aplicado em componentes que devem possuir uma única instância durante a execução do sistema, como o gerenciador de autenticação, o controlador de sessão do usuário ou o serviço de conexão com o banco de dados. Sua utilização permite centralizar o acesso a esses recursos, evitando duplicidade de instâncias e favorecendo maior consistência no funcionamento da aplicação. Conforme o conteúdo estudado, esse padrão é especialmente indicado quando se deseja garantir apenas uma instância de um objeto compartilhado no sistema.

- O padrão **Observer**, por sua vez, pode ser utilizado em situações em que alterações em determinada informação precisam ser refletidas automaticamente em outras partes da aplicação. No contexto do LetterMusic, isso pode ocorrer, por exemplo, quando uma nova avaliação modifica a nota geral de uma música, quando a nota média de um álbum é atualizada ou quando a lista de favoritos do usuário sofre alteração. Nesses casos, o padrão contribui para que os componentes dependentes dessas informações sejam notificados e atualizados de maneira organizada, tornando a interação do sistema mais dinâmica.

- O material da disciplina apresenta o Observer como um padrão comportamental voltado justamente à notificação automática de partes interessadas diante de mudanças de estado. Dessa forma, a adoção desses padrões no projeto contribui para uma melhor separação de responsabilidades, maior clareza na estrutura do sistema e mais facilidade de manutenção e evolução futura da aplicação.

# 4. Metodologia de Projeto
## 4.1. Estrutura do Projeto
### Tabela 7 - Estrutura do projeto
| Integrante               | Cargo                           | Responsabilidade  |
| ------------------------ | ------------------------------- | ------------------------ |
| Chyntia Freitas Prestes  | Desenvolvedora Front End        | Responsável pelo desenvolvimento do frontend da aplicação, pela prototipação das telas e pelo apoio na definição visual e arquitetural do sistema. Também participou da definição inicial da proposta do projeto e da elaboração da arquitetura do sistema.    |
| João Vitor Oliveira Simões       | P.O, Desenvolvedor Backend   | Responsável pelo desenvolvimento do backend da aplicação, pela elaboração dos requisitos funcionais, não funcionais e regras de negócio, além do apoio na modelagem do sistema. Também participou da definição inicial da proposta do projeto e da elaboração do diagrama de atividade. |
| Julia de Souza Farias            | Desenvolvedora Front End     | Responsável pelo apoio ao desenvolvimento do frontend, auxiliando na implementação e ajustes das telas e da interface da aplicação. |
| Laís Samilly Xavier da Silva     | Testadora e Apoiadora do Backend | Responsável pela realização de testes, identificação de falhas, validação das funcionalidades implementadas e apoio complementar no Backend. Também participou da elaboração do diagrama de sequência e do diagrama de objetos. |
| Manoele Braga Colares da Costa   | Desenvolvedora Front End | Responsável pelo desenvolvimento do frontend e pela implementação das telas da aplicação. Também participou da definição inicial da proposta do projeto e da elaboração do diagrama de caso de uso. |
| Tiago dos Santos Mendonça        | Desenvolvedor Backend    | Responsável pelo desenvolvimento do backend da aplicação e apoio na modelagem e integração com o banco de dados. Também participou da elaboração do diagrama de classes. | 

## 4.2  Ambiente de Desenvolvimento
### Tabela 8 - Ambiente de desenvolvimento
| Tipo                                        | Modelo e Especificações     |
| ------------------------------------------- | --------------------------- |
| Plataforma de repositório e versionamento   | GitHub                      |
| Plataforma de Modelagem UML                 | Draw.io                     |
| Modelagem do banco de dados                 | Br modelo                   |
| Plataforma de Design das telas              | Figma                       |
| Ambiente de Desenvolvimento Integrado - IDE | VS code                     |
| Linguagem / Framework Mobile                | Flutter (Dart)              |
| Banco de Dados                              | Cloud Firestore (Firebase)  |

## 4.3 Cronograma
- **Fase I: Especificação e Planejamento – Março/Abril:** 
  A definição da ideia principal do projeto, o levantamento dos requisitos funcionais, não funcionais e das regras de negócio, além do planejamento geral do sistema. Nessa fase, também serão elaborados os diagramas de caso de uso, sequência, classes, atividades e objetos, bem como a arquitetura do sistema e os padrões de projeto adotados. Além disso, será feita a prototipação das telas da aplicação no Figma.

- **Fase II: Correções dos Diagramas – Abril:**
  Revisão e correção dos requisitos e diagramas elaborados anteriormente. Nessa etapa, todos os integrantes da equipe participarão dos ajustes, remoções, adições e modificações necessárias, com o objetivo de melhorar a clareza, a organização e a coerência da documentação e da modelagem do sistema.

- **Fase III: Desenvolvimento Backend – Abril/Maio:**
  A elaboração dos modelos conceitual, lógico e físico do banco de dados, além do desenvolvimento do backend do sistema. Nessa etapa, serão estruturadas as bases necessárias para dar suporte às funcionalidades da aplicação.

- **Fase IV: Desenvolvimento Frontend – Maio/Junho:**
  Desenvolvimento da interface do sistema com base nas telas previamente prototipadas. Nessa fase, serão implementadas as funcionalidades visuais da aplicação e realizada a integração com o backend.
  
- **Fase V: Testes do Sistema implementado e Conclusão – Junho:**
  A execução de testes no sistema implementado, com o objetivo de verificar o funcionamento das funcionalidades desenvolvidas. Também serão feitas pequenas correções e ajustes finais, visando à conclusão da implementação do projeto.
# 5. Análise de Risco
### Tabela 32 - Análise de Risco
| Identificador                           | Descrição               | Impacto                                                                |
| ------------------------------ | ----------------- | ------------------------------------------------------------------------------------- |
| CR001               | Risco de indisponibilidade do servidor ou dos serviços utilizados pela aplicação, comprometendo o acesso às funcionalidades do sistema. | Alto     |
| CR002                   | Risco de falha na coleta de dados provenientes da API externa de músicas, podendo afetar a pesquisa e a exibição de informações musicais.       | Alto |
| CR003     | Risco de falta de mão de obra disponível em determinados períodos do projeto, o que pode gerar atrasos no cronograma e na execução das atividades previstas.       | Médio                             |
| CR004        |  Risco de a equipe apresentar dificuldades técnicas ou habilidades insuficientes em alguma tecnologia adotada, impactando a qualidade e o andamento do desenvolvimento.                 | Médio                                   |

# 6. Apêndice
Esta seção reúne materiais complementares elaborados pela equipe ao longo do desenvolvimento do sistema LetterMusic, com a finalidade de apoiar a compreensão do projeto e registrar informações adicionais relacionadas ao processo de construção da aplicação. Entre esses materiais, podem ser incluídos relatos de experiência, atas de reuniões, registros de decisões tomadas pela equipe, versões complementares de diagramas e demais documentos produzidos durante a elaboração do projeto.

## 6.1 Relato de Experiência
O desenvolvimento do sistema LetterMusic proporcionou à equipe uma experiência prática na elaboração de um aplicativo móvel, envolvendo etapas de planejamento, modelagem, documentação, prototipação e organização das funcionalidades previstas para a aplicação. Durante esse processo, os integrantes puderam aplicar conhecimentos estudados na disciplina, especialmente no que se refere à definição de requisitos, construção de diagramas UML, arquitetura do sistema e estruturação da proposta do projeto.

Além dos aspectos técnicos, o desenvolvimento também exigiu cooperação entre os membros da equipe, divisão de responsabilidades e revisão constante das decisões tomadas ao longo do projeto. Dessa forma, a experiência contribuiu não apenas para a construção do sistema, mas também para o fortalecimento de habilidades relacionadas ao trabalho em grupo, à organização e ao desenvolvimento de soluções voltadas ao contexto da computação móvel.
