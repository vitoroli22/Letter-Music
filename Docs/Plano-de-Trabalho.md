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




### 1.3.3 Tipo
| Tipo                        | Detalhamento                                                                                                                                       |
| --------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------- |
| Desenvolvimento de Software | Criação de um produto de software com sistema de banco de dados em nuvem, com interface focada na experiência do usuário e sistema de privacidade. |

# 2 INFORMAÇÕES GERAIS
## 2.1 Objetivo
Desenvolver uma rede social de homenagens póstumas dedicada a preservar e compartilhar memórias de entes queridos falecidos. Oferecendo ao usuários a funcionalidade de herdar seu perfil a usuários responsáveis para torna-lo um memorial após sua morte. Enfim, oferecendo um ambiente onde amigos e familiares possam se reunir virtualmente para prestar homenagens, compartilhar histórias, fotos, vídeos e recordar os momentos especiais vividos com a pessoa falecida.

## 2.2 Escopo geral
O aplicativo contará com publicações principalmente entre usuários na página do memorial para compartilhar textos, fotos e vídeos em homenagem ao falecido. O sistema terá uma visualização de publicações em sessões, uma maneira de interagir com os momentos mais marcantes da vida da pessoa querida de maneira dinâmica. Controle total sobre quem pode acessar e interagir com o conteúdo, assegurando um ambiente seguro e respeitoso.

### 2.2.1 Escopo Específico
- Criação de Perfil individual.
- Criação da página do memorial do falecido com até 3 perfis responsáveis. Esses perfis poderão aceitar solicitações de acesso a visualização ou publicação de outros usuários.
- O memorial será composto de publicações de diversos usuários. Há destaque a pessoa falecida se o memorial foi criado a base do perfil da mesma antes de falecer.
- Publicação de textos, fotos e vídeos em memória do falecido.
- Implementar ferramentas robustas de controle de privacidade, permitindo que os usuários determinem quem pode visualizar e interagir com o conteúdo compartilhado.
- Permitir que os usuários organizem e destaquem publicações em Sessões de lembranças.
- Integração de ferramentas de edição para publicações.
- Implementação de um layout que permita fácil navegação na Pagina do memorial: Linha de Postagens e Sessões.

### 2.2.2 Escopo Negativo
- O aplicativo não terá financiamento através de anúncios.
- O sistema não incluirá funcionalidades de gamificação para incentivar o uso do aplicativo.
- Não será desenvolvida uma funcionalidade de chat ou mensagens instantâneas entre usuários nesse estágio inicial.

## 2.3 Ambiente de Desenvolvimento
### Ferramentas e Tecnologias
| Tipo                                        | Modelo e Especificações     |
| ------------------------------------------- | --------------------------- |
| Plataforma de repositório e versionamento   | GitHub                      |
| Plataforma de Design                        | Figma                       |
| Ambiente de Desenvolvimento Integrado - IDE | VS code e Android Studio    |
| Linguagem de Programação                    | Kotlin, Python e JavaScript |

## 2.4 Características Inovadoras do Projeto
- O aplicativo permite tornar perfis individuais e suas publicações em paginas de memorial com responsáveis escolhidos pelo mesmo antes de falecer.  
- Republicação de momentos a partir da data especificada ou data de postagem.  

## 2.5 Resultados Esperados
- Uma pagina de memorial personalizável. 
- Armazenamento de informações do usuário e mídia com alta segurança.
- Feedback positivo dos usuários em relação a usabilidade do aplicativo.

# 3 METODOLOGIA DE PROJETO
## 3.1 Estrutura do Projeto
- Scrum Master.
- Equipe de Desenvolvimento.
- Equipe de Design.
- Equipe de Testes.

## 3.2 Equipe de Projeto: Papéis e Responsabilidades dos integrantes
| Responsabilidade        | Profissional                   |
| ----------------------- | ------------------------------ |
| Scrum Master            | Guilherme Kenuy Saavedra Nunes |
| Desenvolvedor Front-End | Laís Samily Xavier de Sousa    |
| Desenvolvedor Back-End  | Manoele Braga Colares da Costa |
| Designer de UX/UI       | Maria Vitória Brasil Campos    |
| Testador de Software    | João Vitor de Oliveira Simões  |

## 3.3 Fases, Atividades e Cronograma
- **Fase I: Especificação – Janeiro/Fevereiro:**
  - Planejamento inicial.
  - Levantamento de requisitos do sistema.
  - Desenvolvimento de Personas.
  - Trabalhar histórias do usuário e seus critérios de aceitação e regras de negócios.

- **Fase II: Inspeção – Março/Abril:**
  - Revisão dos requisitos do sistema.

- **Fase III: Projeto e Arquitetura – Maio/Junho:**
  - Design da arquitetura do sistema através de diagramas dinâmicos e estáticos.

- **Fase IV: Prototipagem e Refinamento – Julho:**

- **Fase V: Prototipagem e Refinamento – Agosto:**

- **Fase VI: Encerramento – Setembro**

## 3.4 Entregas de cada Fase
| Fase                           | Mês               | Entregável                                                                            |
| ------------------------------ | ----------------- | ------------------------------------------------------------------------------------- |
| I. Especificação               | Janeiro/Fevereiro | Personas, Histórias do Usuários e Requisitos do sistema.                              |
| II. Inspeção                   | Março/Abril       | Resolução de defeitos apontados na Inspeção. Mudanças e Melhorias de Funcionalidades. |
| III. Projeto e Arquitetura     | Maio/Junho        | Diagramas de Classes, Diagrama de Sequencia e Modelo C4                               |
| IV. Prototipagem e Refinamento |                   |                                                                                       |
| V. Encerramento                |                   |                                                                                       |

## 3.5 Controle de Mudanças
O monitoramento e controle do escopo do projeto serão realizados a partir das seguintes diretrizes:

- Requisitos do projeto devem ser compreendidos por todos os membros da equipe.
- Todas as questões técnicas, de entregas e do cronograma que a equipe do projeto possui devem ser respondidas.
- Todas as entregas devem ser acordadas pela equipe do projeto e entidades parceiras.
- Todas as informações devem estar atualizadas no escopo e não-escopo.
- Nenhum trabalho fora do escopo do projeto deve ser feito.
- Solicitações de mudança no escopo do projeto devem ser efetivamente comunicadas e compreendidas.
