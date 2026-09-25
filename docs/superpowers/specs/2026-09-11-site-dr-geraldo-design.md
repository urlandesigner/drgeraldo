# Site Dr. Geraldo Andrade do Norte — Especificação de Design

**Data:** 2026-09-11
**Status:** Aprovado para planejamento de implementação

---

## 1. Contexto

O Dr. Geraldo Andrade do Norte (CRM-ES 10212) atende em Vila Velha/ES, em consultório
particular, com foco em obesidade, tireoide, hormônios e metabolismo. Hoje não tem site.
Sua presença digital se resume a um perfil no Doctoralia com 13 avaliações, praticamente
todas máximas.

**Esta v1 não é o site dele. É a peça de venda do projeto.** O objetivo do entregável é
fazer o Dr. Geraldo aprovar a contratação. Todas as decisões abaixo são otimizadas para
esse alvo — sem prejuízo de o material virar o site real depois, com as pendências
preenchidas.

## 2. Público

Paciente leigo, 30 a 55 anos, lidando com peso, cansaço, tireoide ou alterações
hormonais. Chega por busca ou indicação. Frequentemente já passou por outros médicos e
saiu sem entender o próprio diagnóstico. Acessa pelo celular.

## 3. Posicionamento — o argumento central

Site de médico normalmente abre com "Endocrinologista em [cidade] — agende sua consulta".
Isso não diferencia nada, porque todo concorrente diz o mesmo.

O Dr. Geraldo tem um diferencial raro e já documentado por 13 pacientes: **ele explica,
olha no olho, e o paciente sai sem dúvida.** Citações recorrentes: *"explica as coisas
olhando nos seus olhos"*, *"você sai do consultório sem nenhuma dúvida"*.

O site inteiro existe para **provar isso antes da consulta acontecer**. A própria página
funciona como amostra do jeito dele atender: se o texto explica com clareza e sem pressa,
o leitor conclui sozinho que a consulta será assim.

Consequência prática: a qualidade da redação não é decoração deste projeto. É o produto.

## 4. Benchmark — o que foi verificado

Analisados cinco sites: Dra. Queulla Garret (concorrente direta em Vila Velha),
Dr. Eduardo Henrique, Dra. Débora Mello e Dr. Carlos Seraphim (referências nacionais em
emagrecimento).

**Padrões universais (seguir):**
- Todos exibem CRM. Obrigatório.
- Todos os CTAs terminam em WhatsApp, mesmo quando o botão diz "Agendar".
- Nenhum exibe preço.

**Brechas identificadas (explorar):**
1. **Ninguém descreve como é a consulta.** Nenhum dos quatro explica o processo. A seção
   "Como é a consulta" é espaço vazio no mercado inteiro.
2. **"Humanizado" virou commodity.** Queulla usa "abordagem humanizada"; Eduardo usa
   "individualizada e humanizada". Alegação idêntica, prova zero. O Dr. Geraldo é o único
   que pode provar com depoimentos espontâneos.
3. **Transparência sobre convênio.** Ele é 100% particular, e isso aparece como a única
   frustração real nas avaliações. Declarar de frente, com o motivo, é diferenciação.

**Copiar:** Dr. Eduardo lista "exames inclusos na primeira consulta" — concreto, antecipa
dúvida. Dr. Seraphim ensina em vez de vender, desmistificando mitos.

**Evitar:** Dr. Seraphim tem seção "Meus Números" com métricas de desempenho — perigosamente
próximo de promessa de resultado.

**Achado crítico:** a concorrente direta exibe CRM **e RQE** (registro de qualificação de
especialista, que é o que autoriza anunciar-se como "endocrinologista"). O Dr. Geraldo
aparece no Doctoralia como "Generalista", sem RQE listado. Não se sabe se é cadastro
incompleto ou situação real. Ver seção 10.

## 5. Escopo da v1

**Dentro:**
- Uma página única (`index.html`) com conteúdo completo e definitivo, seções ancoradas.
- Identidade visual derivada das cores do IMI (Instituto Médico Itapoã), clínica onde ele atende.
- Marca em wordmark tipográfico com o nome dele. Sem logo gráfico.
- Textos escritos por completo, com pendências marcadas visivelmente.
- Deploy em URL temporária para apresentação.

**Fora:**
- Blog, CMS, área administrativa, banco de dados, backend, formulário.
- Agendamento online.
- Múltiplas páginas.
- Domínio próprio (só após aprovação dele).
- Analytics e cookies.

**Por que sem blog:** ninguém se comprometeu a produzir conteúdo recorrente. Blog com
último post de dois anos atrás destrói autoridade em vez de construir. O site é fixo,
bem escrito, e envelhece bem.

## 6. Arquitetura da página

Seções em ordem. A ordem é um argumento sendo construído, não uma lista.

### 6.1 Navegação fixa
Wordmark "Dr. Geraldo Andrade do Norte" com "CRM-ES 10212" em corpo menor abaixo.
Âncoras: Sobre · A consulta · O que trato · Pacientes · Consultório · Dúvidas.
Botão WhatsApp sempre visível.
No mobile, as âncoras rolam horizontalmente. **Sem menu hambúrguer** — evita JavaScript.

### 6.2 Abertura
H1 com a promessa de clareza, não com a palavra-chave. Direção:
*"Você vai sair da consulta entendendo o que está acontecendo com o seu corpo."*

Subtítulo situando: foco em obesidade, tireoide e metabolismo, em Vila Velha, consulta
particular, sem pressa. Foto do médico. CTA primário para WhatsApp. Selo discreto:
"13 avaliações verificadas no Doctoralia", com link.

### 6.3 O incômodo
Nomeia a dor para o leitor se reconhecer. Consulta de dez minutos; exame na mão e um
"está tudo normal"; dieta genérica impressa; remédio sem explicação; sair sem entender.
Fecha com a ponte: a consulta dele começa pelo oposto — entender.

Seção curta. Empatia, nunca autopromoção.

### 6.4 Sobre o Dr. Geraldo
Foto e texto **em primeira pessoa** — escolha deliberada: aproxima, e é coerente com um
médico cujo diferencial é a conversa. Formação, residência, tempo de atuação, sociedades.
CRM-ES 10212 explícito.

Campos dependentes de material dele ficam como placeholder marcado (ver seção 11).

### 6.5 Como é a consulta
**A seção mais estratégica do site, e a que nenhum concorrente tem.** Transforma "ele
explica bem" — elogio vago — em processo verificável. Quatro passos:

1. **A conversa** — história completa, sem cronômetro.
2. **Avaliação e exames** — o que se pede e por que se pede.
3. **O plano** — explicado até você entender, não entregue impresso.
4. **O acompanhamento** — ajuste ao longo do tempo.

Inclui um bloco honesto: **"Por que às vezes a agenda atrasa."** A única crítica recorrente
nas avaliações é a espera. Não se pede desculpa: explica-se que a consulta não tem hora
para acabar, e que é exatamente por isso que às vezes atrasa. A fraqueza vira a prova da tese.

### 6.6 O que eu trato
Três blocos, com profundidade real. Cada um responde: o que é, sinais comuns, como é a
abordagem, e o que **não** se promete.

1. **Obesidade e emagrecimento** — o tema mais citado nas avaliações e o de maior busca.
   Desmistificar: obesidade é doença crônica, não falta de força de vontade.
2. **Tireoide e hormônios** — público que chega com exame na mão e sem explicação.
   Encaixe direto no diferencial.
3. **Composição corporal** — ganho de massa e performance. **Tema mais sensível do ponto de
   vista de publicidade médica**: escrever com cuidado para não soar promessa estética.

Diabetes ficou deliberadamente de fora, deslocando o posicionamento de "médico de doença
crônica" para metabolismo, corpo e qualidade de vida.

### 6.7 O que dizem os pacientes
Três ou quatro depoimentos reais do Doctoralia, com data e crédito explícito à fonte, mais
link para o perfil. Prova social de terceiro verificável é mais forte que autoelogio, e
mais defensável eticamente que texto sem origem.

### 6.8 O consultório
Endereço, referência de como chegar, horários, telefone. **Mapa como imagem estática com
link "abrir no Google Maps"**, nunca iframe — evita cookie de terceiro e peso de carregamento.

### 6.9 Dúvidas frequentes
`<details>` nativo, sem JavaScript. Perguntas: atende convênio? atende online? preciso
levar exames? quanto tempo dura a consulta? trata só emagrecimento? como marco?

A do convênio é a mais importante: ele é 100% particular. Esconder isso gera paciente
irritado ligando à toa e desgasta a secretária. Declarar de frente, e usar a favor —
atendimento particular é o que permite a consulta sem pressa.

### 6.10 Rodapé
Wordmark, CRM-ES 10212, endereço, WhatsApp, e o aviso: "Este site tem caráter informativo
e não substitui consulta médica."

## 7. Identidade visual

Paleta derivada da fachada do IMI, com neutros acrescentados:

```
--azul-institucional : #1B3F91   títulos, navegação, rodapé
--azul-claro         : #31A3DC   links, CTA, detalhes
--cinza-texto        : #3A4454   texto corrido
--cinza-fundo        : #F4F7FB   fundo de seções alternadas
--borda              : #E2E8F2   linhas e cards
--branco             : #FFFFFF
```

**Tipografia — escolha deliberada contra o mercado.** Todos os concorrentes usam sans-serif,
o que gera um ar clínico, frio e indistinguível entre eles. Aqui: **serif nos títulos (Lora)
e sans no corpo (Inter)**. Serif carrega autoridade e calor; é tipografia de quem escreve,
não de quem anuncia. Coerente com um médico cujo diferencial é sentar e explicar.

**O site é feito para ser lido, não escaneado.** Corpo em 18px, linha com cerca de 68
caracteres, respiro generoso entre blocos. A diagramação comunica "aqui existe tempo".

**Proibido no projeto:** banco de imagens com jaleco e estetoscópio; ícones decorativos de
saúde; contadores de números; gradientes coloridos; antes e depois.

## 8. Decisões técnicas

Três artefatos: `index.html`, `styles.css`, `/img`.

- **Zero JavaScript.** FAQ com `<details>`, navegação com âncoras. Menos código, mais rápido,
  não quebra.
- **Design tokens em `:root`** no CSS. Trocar identidade depois é mudança em um arquivo só —
  importante porque a paleta é emprestada do IMI e pode precisar sair.
- **Mobile-first.** O tráfego será majoritariamente celular.
- **Acessibilidade:** contraste AA, foco visível, hierarquia correta de headings, `alt` em
  todas as imagens. É a mesma disciplina que o Google lê.
- **SEO:** `title`, `meta description`, e `JSON-LD` do tipo `Physician` com endereço.
- **Open Graph caprichado.** Ele vai divulgar esse link pelo WhatsApp — é assim que o site
  será visto primeiro. O preview precisa ficar bom.
- **Performance:** imagens otimizadas, fontes com `preconnect` e `display=swap`.
- **Deploy:** Vercel, URL temporária.

**Custo aceito conscientemente:** HTML puro sem build significa que, se um dia houver mais
páginas, header e rodapé serão duplicados. Com página única isso não existe hoje. Fica
registrado para a v2.

## 9. Conformidade

### CFM
- CRM-ES 10212 visível no topo e no rodapé.
- Nenhuma promessa ou garantia de resultado.
- Nenhuma imagem de antes e depois.
- Nenhum superlativo: "o melhor", "referência em", "o maior".
- Sem preço. Sem métricas de desempenho.

### Depoimentos — item aberto
Reproduzidos com crédito e link ao Doctoralia, nunca como texto próprio do site.
**Validar o enquadramento atual de depoimento de paciente em publicidade médica junto ao
CRM-ES antes de publicar.**

**Segundo item aberto, decidido pelo cliente em 2026-09-24:** três dos quatro depoimentos
estão anônimos; o quarto traz o nome completo do paciente, como publicado no Doctoralia.
O cliente optou por **manter o nome**. Publicar nome completo ligado a atendimento médico,
no site do próprio médico, é tratamento de dado sensível de saúde fora do contexto original
em que a pessoa publicou. Confirmar consentimento do próprio paciente antes de ir ao ar,
ou anonimizar na publicação. Não há certeza sobre a regra vigente e não se deve chutar em
matéria que gera processo ético. Se houver vedação, substituir a seção 6.7 por um link
simples ao perfil do Doctoralia.

### LGPD
Resolvida por arquitetura: sem formulário, sem banco, sem cookie, sem Analytics. Nada é
coletado, então não há o que proteger. Analytics numa fase futura exige aviso de cookies.

## 10. Regras de redação

Regras verificáveis, não preferências de estilo:

1. **A palavra "endocrinologista" nunca é usada como título dele.** Usar "atendimento com
   foco em endocrinologia e metabologia", "consulta voltada a obesidade, tireoide e
   metabolismo". Isso é verdadeiro tanto se ele tiver RQE quanto se não tiver. Se ele
   confirmar o RQE, a troca são poucas frases.
2. **A palavra "humanizado" é proibida.** É commodity no mercado. Mostrar, não afirmar.
3. **Proibidos:** "o melhor", "referência em", "resultados garantidos", "transforme seu corpo",
   "mude sua vida".
4. **Voz:** segunda pessoa para o leitor ("você"), primeira para o médico ("eu").
5. **Todo termo técnico é explicado na mesma frase em que aparece.** É o site inteiro
   imitando o jeito dele de atender.
6. Frases curtas. Parágrafos curtos.

## 11. Pendências

| # | Pendência | Impacto | Tratamento na v1 |
|---|---|---|---|
| 1 | Arquivos das fotos profissionais | Abertura e Sobre | Placeholder marcado |
| 2 | Bio e formação (faculdade, residência, tempo, sociedades) | Sobre | Lacunas marcadas |
| 3 | Confirmação de RQE | Todo o texto | Contornado pela regra 10.1 |
| 4 | WhatsApp correto — os números da fachada (27 99804-2173, 27 3061-3233) são do IMI | Todos os CTAs | Placeholder marcado |
| 5 | **Endereço definitivo — conflito real:** Doctoralia indica R. Humberto Serrano; o IMI fica em Itapoã | Consultório e JSON-LD | Placeholder marcado |
| 6 | Horário de atendimento | Consultório e JSON-LD | Placeholder marcado |
| 7 | Autorização para usar as cores do IMI | Identidade inteira | Assumida; tokens permitem trocar |

Os placeholders são **visivelmente marcados de propósito**. Mostram ao Dr. Geraldo
exatamente o que precisa ser fornecido, e transformam a apresentação numa conversa de
trabalho em vez de um "o que você acha?".

## 12. Critérios de aceite

- [ ] Zero arquivos `.js`; nenhuma tag `<script>` exceto o bloco JSON-LD.
- [ ] Lighthouse igual ou acima de 95 em Performance, Acessibilidade, Boas Práticas e SEO.
- [ ] Layout íntegro em viewport de 360px.
- [ ] Contraste AA em todo texto.
- [ ] "CRM-ES 10212" presente no topo e no rodapé.
- [ ] Busca por "humanizado", "endocrinologista", "o melhor", "garantido" no HTML não
      retorna ocorrência — exceto "endocrinologia" como área, nunca como título dele.
- [ ] Todos os placeholders visualmente distinguíveis do conteúdo final.
- [ ] Todas as dez seções da seção 6 presentes e com texto real, não lorem ipsum.
- [ ] Preview de Open Graph renderiza corretamente ao compartilhar.

## 13. A revisitar na v2

- **Dependência da marca do IMI.** As cores são de terceiro. Se ele sair da clínica, o
  visual fica órfão. Irrelevante para uma peça de venda; relevante para o site definitivo.
- **Domínio próprio**, após aprovação.
- **Blog**, apenas se alguém assumir de fato a produção recorrente.
- **Analytics**, com o aviso de cookies correspondente.
- **Páginas separadas por tema**, se houver estratégia de SEO — e aí o HTML puro precisa
  ser reavaliado por causa da duplicação de header e rodapé.
