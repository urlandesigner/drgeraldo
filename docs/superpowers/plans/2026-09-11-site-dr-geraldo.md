# Site Dr. Geraldo — Plano de Implementação

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Construir uma página única estática que sirva como peça de venda do projeto ao Dr. Geraldo, com conteúdo definitivo e pendências visivelmente marcadas.

**Architecture:** HTML e CSS puros, sem build e sem JavaScript. Um `index.html` com dez seções ancoradas, um `styles.css` com design tokens em `:root`, e um `verify.sh` que automatiza os critérios de aceite da especificação. Deploy estático na Vercel.

**Tech Stack:** HTML5, CSS3 (custom properties, flexbox, grid), Google Fonts (Lora + Inter), `verify.sh` em bash, Vercel CLI.

**Spec:** `docs/superpowers/specs/2026-09-11-site-dr-geraldo-design.md`

## Global Constraints

Valem para **todas** as tasks. O `verify.sh` checa cada uma.

- **Zero JavaScript.** Nenhum arquivo `.js`. Nenhuma tag `<script>` exceto o bloco `application/ld+json`.
- **A palavra "endocrinologista" nunca aparece.** Usar "endocrinologia e metabologia" como área. Motivo: não há confirmação de RQE.
- **A palavra "humanizado" (e variações) nunca aparece.** É commodity no mercado.
- **Proibidas:** "o melhor", "referência em", "resultados garantidos", "transforme seu corpo", "mude sua vida".
- **Sem preço.** Sem métricas de desempenho. Sem antes e depois.
- **"CRM-ES 10212"** aparece no mínimo duas vezes: navegação e rodapé.
- `<html lang="pt-BR">`.
- Toda `<img>` tem atributo `alt` não vazio.
- Voz: segunda pessoa para o leitor ("você"), primeira para o médico ("eu").
- Todo termo técnico é explicado na mesma frase em que aparece.
- Pendências marcadas com a classe `.pendente` e o texto entre colchetes, ex: `[PENDENTE: ano de formação]`.

## Paleta e tipografia (valores exatos)

```
--azul-institucional : #1B3F91
--azul-claro         : #31A3DC   (decorativo: marcadores, bordas)
--azul-acao          : #1B739F   (texto, botão, foco — passa AA sobre branco E sobre o cinza)
--cinza-texto        : #3A4454
--cinza-fundo        : #F4F7FB
--borda              : #E2E8F2
--branco             : #FFFFFF
--pendente-fundo     : #FFF4CC
--pendente-borda     : #E0B400
```

**Por que dois azuis.** O `--azul-claro` da fachada do IMI dá apenas 2,84:1 com texto
branco e reprova no WCAG AA, que é critério de aceite da spec. O `--azul-acao` tem a
mesma matiz (200°) e saturação (71%), só mais escuro: 5,25:1 sobre branco e 4,89:1 sobre
o `--cinza-fundo` das seções alternadas — o fundo cinza é o teste mais exigente, porque as
seções de depoimentos e de dúvidas têm links. Regra: `--azul-claro`
para decoração, `--azul-acao` para qualquer coisa com texto, botão ou foco.

Títulos: `'Lora', Georgia, serif`. Corpo: `'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif`.
Corpo em `18px`, `line-height 1.7`, medida máxima `68ch`.

## File Structure

| Arquivo | Responsabilidade |
|---|---|
| `index.html` | A página inteira: head com SEO/OG/JSON-LD e as dez seções |
| `styles.css` | Tokens em `:root`, reset, tipografia, layout, responsivo |
| `verify.sh` | Harness de verificação dos critérios de aceite |
| `img/dr-geraldo.svg` | Retrato — placeholder SVG até a pendência 1 (troca para `.jpg` com a foto real) |
| `img/mapa-consultorio.svg` | Mapa estático — placeholder SVG até a pendência 5 |
| `img/og-cover.jpg` | Imagem de compartilhamento |
| `vercel.json` | Configuração mínima de deploy estático |

**Classes sem regra CSS, de propósito.** As classes `.sobre`, `.consulta`, `.trato`,
`.pacientes`, `.consultorio` e `.hero__texto` aparecem na marcação sem nenhuma regra
correspondente. São ganchos semânticos para ajuste futuro — o layout funciona sem elas.
Ninguém esqueceu de escrever esse CSS.

Ordem das seções e seus `id`, na ordem em que aparecem no documento:
`topo`, `sobre`, `consulta`, `trato`, `pacientes`, `consultorio`, `duvidas`.
As seções "Abertura", "O incômodo" e "Rodapé" não recebem `id` porque não são alvo de âncora.

---

### Task 1: Fundação e harness de verificação

**Files:**
- Create: `verify.sh`
- Create: `index.html`
- Create: `styles.css`
- Create: `img/.gitkeep`

**Interfaces:**
- Consumes: nada.
- Produces: `verify.sh` executável que retorna 0 quando tudo passa e 1 quando falha. Os tokens CSS em `:root` listados acima. Os `id` das seções, que as tasks seguintes preenchem.

- [ ] **Step 1: Escrever o harness de verificação (o "teste")**

Criar `verify.sh`:

```bash
#!/usr/bin/env bash
# Verifica os critérios de aceite da spec.
set -u
falhas=0

ok()    { printf '  \033[32mok\033[0m    %s\n' "$1"; }
falha() { printf '\033[31mFALHA\033[0m   %s\n' "$1"; falhas=$((falhas+1)); }

# --- Zero JavaScript ---
if [ -z "$(find . -name '*.js' -not -path './node_modules/*' -not -path './.git/*')" ]; then
  ok "nenhum arquivo .js"
else
  falha "existe arquivo .js no projeto"
fi

scripts=$(tr '\n' ' ' < index.html | grep -o '<script[^>]*>' | grep -v 'application/ld+json' || true)
if [ -z "$scripts" ]; then
  ok "nenhuma tag <script> fora do JSON-LD"
else
  falha "tag <script> indevida: $scripts"
fi

# --- Palavras proibidas ---
for termo in endocrinologista humanizad "o melhor" "referência em" "resultados garantidos" "transforme seu corpo" "mude sua vida"; do
  if grep -qi "$termo" index.html; then
    falha "palavra proibida encontrada: '$termo'"
  else
    ok "ausente: '$termo'"
  fi
done

# --- CRM ---
crm=$(grep -o 'CRM-ES 10212' index.html | wc -l | tr -d ' ')
if [ "$crm" -ge 2 ]; then
  ok "CRM-ES 10212 aparece $crm vezes (mínimo 2)"
else
  falha "CRM-ES 10212 aparece $crm vezes, esperado no mínimo 2"
fi

# --- Idioma ---
if grep -q '<html lang="pt-BR"' index.html; then
  ok 'html lang="pt-BR"'
else
  falha 'falta <html lang="pt-BR">'
fi

# --- Seções obrigatórias ---
for secao in topo sobre consulta trato pacientes consultorio duvidas; do
  if grep -q "id=\"$secao\"" index.html; then
    ok "seção #$secao presente"
  else
    falha "seção #$secao ausente"
  fi
done

# --- Imagens com alt ---
sem_alt=$(tr '\n' ' ' < index.html | grep -o '<img[^>]*>' | grep -v 'alt="[^"]\+"' || true)
if [ -z "$sem_alt" ]; then
  ok "todas as <img> têm alt preenchido"
else
  falha "img sem alt: $sem_alt"
fi

# --- Metadados ---
for meta in '<title>' 'name="description"' 'property="og:title"' 'property="og:description"' 'property="og:image"' 'application/ld+json'; do
  if grep -q "$meta" index.html; then
    ok "metadado presente: $meta"
  else
    falha "metadado ausente: $meta"
  fi
done

echo
if [ "$falhas" -eq 0 ]; then
  printf '\033[32mTudo passou.\033[0m\n'; exit 0
else
  printf '\033[31m%d falha(s).\033[0m\n' "$falhas"; exit 1
fi
```

- [ ] **Step 2: Tornar executável e rodar para confirmar que falha**

```bash
chmod +x verify.sh && ./verify.sh
```

Esperado: FALHA — `index.html` não existe ainda, então `grep` reclama e as checagens de seção falham. É o vermelho esperado.

- [ ] **Step 3: Criar o esqueleto do `index.html` com o `<head>` completo**

```html
<!DOCTYPE html>
<html lang="pt-BR">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Dr. Geraldo Andrade do Norte — Obesidade, tireoide e metabolismo em Vila Velha</title>
<meta name="description" content="Consulta com foco em obesidade, tireoide e metabolismo, em Vila Velha. Atendimento particular, sem hora para acabar. CRM-ES 10212.">

<meta property="og:type" content="website">
<meta property="og:title" content="Dr. Geraldo Andrade do Norte">
<meta property="og:description" content="Você vai sair da consulta entendendo o que está acontecendo com o seu corpo.">
<meta property="og:image" content="img/og-cover.jpg">
<meta property="og:locale" content="pt_BR">
<meta name="twitter:card" content="summary_large_image">

<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600&family=Lora:wght@500;600&display=swap" rel="stylesheet">
<link rel="stylesheet" href="styles.css">

<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "Physician",
  "name": "Dr. Geraldo Andrade do Norte",
  "medicalSpecialty": "Endocrinology",
  "address": {
    "@type": "PostalAddress",
    "addressLocality": "Vila Velha",
    "addressRegion": "ES",
    "addressCountry": "BR"
  },
  "availableService": [
    { "@type": "MedicalProcedure", "name": "Obesidade e emagrecimento" },
    { "@type": "MedicalProcedure", "name": "Tireoide e hormônios" },
    { "@type": "MedicalProcedure", "name": "Composição corporal" }
  ]
}
</script>
</head>
<body>

<header id="topo"></header>
<main>
  <section id="sobre"></section>
  <section id="consulta"></section>
  <section id="trato"></section>
  <section id="pacientes"></section>
  <section id="consultorio"></section>
  <section id="duvidas"></section>
</main>
<footer></footer>

</body>
</html>
```

Nota: o `<script type="application/ld+json">` é dado estruturado, não código executável. O `verify.sh` o isenta explicitamente.

- [ ] **Step 4: Criar `styles.css` com tokens e base tipográfica**

```css
:root {
  --azul-institucional: #1B3F91;
  --azul-claro: #31A3DC;
  --azul-acao: #1B739F;
  --cinza-texto: #3A4454;
  --cinza-fundo: #F4F7FB;
  --borda: #E2E8F2;
  --branco: #FFFFFF;
  --pendente-fundo: #FFF4CC;
  --pendente-borda: #E0B400;

  --fonte-titulo: 'Lora', Georgia, serif;
  --fonte-corpo: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;

  --medida: 68ch;
  --gap: 1.25rem;
  --secao-y: 4.5rem;
}

*, *::before, *::after { box-sizing: border-box; }

body {
  margin: 0;
  font-family: var(--fonte-corpo);
  font-size: 18px;
  line-height: 1.7;
  color: var(--cinza-texto);
  background: var(--branco);
  -webkit-font-smoothing: antialiased;
}

h1, h2, h3 {
  font-family: var(--fonte-titulo);
  color: var(--azul-institucional);
  line-height: 1.25;
  margin: 0 0 var(--gap);
}

h1 { font-size: clamp(1.9rem, 5vw, 3rem); }
h2 { font-size: clamp(1.5rem, 3.5vw, 2.1rem); }
h3 { font-size: 1.2rem; }

p { margin: 0 0 var(--gap); max-width: var(--medida); }

a { color: var(--azul-acao); }
a:focus-visible, button:focus-visible, summary:focus-visible {
  outline: 3px solid var(--azul-acao);
  outline-offset: 3px;
}

img { max-width: 100%; height: auto; display: block; }

.container {
  width: min(100% - 2.5rem, 68rem);
  margin-inline: auto;
}

section { padding-block: var(--secao-y); }
section:nth-of-type(even) { background: var(--cinza-fundo); }

/* Marcador visível de pendência — intencional na v1 de apresentação. */
.pendente {
  background: var(--pendente-fundo);
  border-bottom: 2px dashed var(--pendente-borda);
  padding: 0 .25em;
  font-style: normal;
}

.cta {
  display: inline-block;
  background: var(--azul-acao);
  color: var(--branco);
  font-weight: 600;
  text-decoration: none;
  padding: .85rem 1.6rem;
  border-radius: 6px;
}
.cta:hover { background: var(--azul-institucional); }
```

- [ ] **Step 5: Criar a pasta de imagens**

```bash
mkdir -p img && touch img/.gitkeep
```

- [ ] **Step 6: Rodar a verificação**

```bash
./verify.sh
```

Esperado: todas as checagens de estrutura, metadados, idioma e palavras proibidas passam. **Falha esperada:** "CRM-ES 10212 aparece 1 vezes, esperado no mínimo 2" — a única ocorrência nesta task está na `meta description`; a segunda entra na Task 2 (navegação) e a terceira na Task 8 (rodapé). Também falha a checagem de `<img>` apenas se houver imagem, o que ainda não há.

- [ ] **Step 7: Commit**

```bash
git add verify.sh index.html styles.css img/.gitkeep
git commit -m "feat: fundação do site e harness de verificação"
```

---

### Task 2: Navegação fixa e wordmark

**Files:**
- Modify: `index.html` — o `<header id="topo">`
- Modify: `styles.css` — adicionar ao final

**Interfaces:**
- Consumes: `.container`, `.cta` e os tokens da Task 1.
- Produces: a classe `.nav`, e o link de WhatsApp com a classe `.cta`, reutilizado nas seções seguintes. Estabelece a marcação `<span class="pendente">` para pendências.

- [ ] **Step 1: Substituir o `<header id="topo">` pelo conteúdo**

```html
<header id="topo" class="nav">
  <div class="container nav__wrap">
    <a class="marca" href="#topo">
      <strong>Dr. Geraldo Andrade do Norte</strong>
      <small>CRM-ES 10212</small>
    </a>
    <nav class="nav__links" aria-label="Navegação principal">
      <a href="#sobre">Sobre</a>
      <a href="#consulta">A consulta</a>
      <a href="#trato">O que trato</a>
      <a href="#pacientes">Pacientes</a>
      <a href="#consultorio">Consultório</a>
      <a href="#duvidas">Dúvidas</a>
    </nav>
    <a class="cta cta--nav" href="https://wa.me/5527000000000" target="_blank" rel="noopener">
      WhatsApp
    </a>
  </div>
</header>
```

Nota: `5527000000000` é placeholder da pendência 4. Fica assim até o número real chegar, e a Task 9 tem um passo que confirma que ele ainda está marcado.

- [ ] **Step 2: Estilizar — sem menu hambúrguer, sem JavaScript**

```css
.nav {
  position: sticky; top: 0; z-index: 10;
  background: var(--branco);
  border-bottom: 1px solid var(--borda);
  padding-block: .7rem;
}
.nav__wrap {
  display: flex; align-items: center; gap: 1.5rem; flex-wrap: wrap;
}
.marca { text-decoration: none; line-height: 1.2; }
.marca strong {
  display: block;
  font-family: var(--fonte-titulo);
  font-size: 1.05rem;
  color: var(--azul-institucional);
}
.marca small {
  display: block;
  font-size: .74rem;
  letter-spacing: .06em;
  color: var(--cinza-texto);
}
.nav__links {
  display: flex; gap: 1.25rem;
  margin-inline-start: auto;
  overflow-x: auto;
  -webkit-overflow-scrolling: touch;
}
.nav__links a {
  color: var(--cinza-texto);
  text-decoration: none;
  font-size: .95rem;
  white-space: nowrap;
  padding-block: .25rem;
}
.nav__links a:hover { color: var(--azul-acao); }
.cta--nav { padding: .55rem 1.1rem; font-size: .92rem; }

@media (max-width: 860px) {
  .nav__wrap { flex-wrap: wrap; }
  .marca { width: 100%; }
  .nav__links { flex: 1; margin-inline-start: 0; }
  .cta--nav { flex: none; }
}
```

No mobile os links viram uma faixa de rolagem horizontal. É deliberado: um menu hambúrguer exigiria JavaScript ou o truque do checkbox, e com seis âncoras a faixa é mais rápida de usar.

- [ ] **Step 3: Rodar a verificação**

```bash
./verify.sh
```

Esperado: `CRM-ES 10212 aparece 1 vezes, esperado no mínimo 2` — ainda falta o rodapé, que é a Task 8. Todo o resto passa.

- [ ] **Step 4: Conferir visualmente em duas larguras**

```bash
open index.html
```

Confirmar: a navegação gruda no topo ao rolar; em 360px de largura os links rolam horizontalmente e nada estoura para fora da tela.

- [ ] **Step 5: Commit**

```bash
git add index.html styles.css
git commit -m "feat: navegação fixa com wordmark e CRM"
```

---

### Task 3: Abertura e seção "O incômodo"

**Files:**
- Modify: `index.html` — inserir duas `<section>` antes de `<section id="sobre">`
- Modify: `styles.css`
- Create: `img/dr-geraldo.jpg` (placeholder)

**Interfaces:**
- Consumes: `.container`, `.cta`, `.pendente`.
- Produces: `.hero`, `.hero__selo`, `.incomodo`.

- [ ] **Step 1: Gerar o placeholder da foto**

Um JPEG falso feito com `printf` renderiza como ícone de imagem quebrada — inaceitável no topo
de uma peça de venda. O placeholder é um SVG válido e visivelmente marcado. A dimensão alvo
da foto real é 800×1000px; quando a pendência 1 for resolvida, troca-se o arquivo e o `src`.

- [ ] **Step 2: Inserir a abertura e o incômodo**

Inserir logo após `<main>` e antes de `<section id="sobre">`:

```html
<section class="hero">
  <div class="container hero__wrap">
    <div class="hero__texto">
      <h1>Você vai sair da consulta entendendo o que está acontecendo com o seu corpo.</h1>
      <p class="hero__sub">
        Consulta com foco em obesidade, tireoide e metabolismo, em Vila Velha.
        Atendimento particular, sem hora para acabar.
      </p>
      <a class="cta" href="https://wa.me/5527000000000" target="_blank" rel="noopener">
        Falar com a secretária no WhatsApp
      </a>
      <p class="hero__selo">
        <a href="https://www.doctoralia.com.br/geraldo-andrade-do-norte/generalista/vila-velha"
           rel="noopener">13 avaliações verificadas no Doctoralia</a>
      </p>
    </div>
    <img class="hero__foto" src="img/dr-geraldo.svg"
         alt="Retrato do Dr. Geraldo Andrade do Norte"
         width="800" height="1000">
  </div>
</section>

<section class="incomodo">
  <div class="container">
    <h2>Se você já saiu do consultório com o exame na mão e sem resposta</h2>
    <p>
      Dez minutos de consulta. Um exame que "está normal". Uma dieta impressa igual
      à do paciente anterior. Um remédio novo, sem ninguém explicar para que serve.
    </p>
    <p>
      Você sai com a receita e sem entender o que está acontecendo com o seu corpo —
      que era exatamente o que você foi buscar.
    </p>
    <p><strong>Aqui a consulta começa pelo contrário: entender primeiro.</strong></p>
  </div>
</section>
```

- [ ] **Step 3: Estilizar**

```css
.hero { padding-block: 3.5rem var(--secao-y); background: var(--branco); }
.hero__wrap {
  display: grid; gap: 2.5rem; align-items: center;
  grid-template-columns: 1.15fr .85fr;
}
.hero__sub { font-size: 1.12rem; }
.hero__foto {
  border-radius: 10px;
  box-shadow: 0 18px 40px rgba(27, 63, 145, .14);
}
.hero__selo { margin-top: 1.1rem; font-size: .92rem; }

.incomodo { background: var(--cinza-fundo); }
.incomodo p { font-size: 1.05rem; }

@media (max-width: 820px) {
  .hero__wrap { grid-template-columns: 1fr; }
  .hero__foto { order: -1; max-width: 320px; }
}
```

- [ ] **Step 4: Rodar a verificação**

```bash
./verify.sh
```

Esperado: a checagem de `alt` agora roda e passa. Segue falhando só o CRM (1 de 2).

- [ ] **Step 5: Commit**

```bash
git add index.html styles.css img/dr-geraldo.svg
git commit -m "feat: abertura e seção de identificação com a dor do paciente"
```

---

### Task 4: Sobre o Dr. Geraldo

**Files:**
- Modify: `index.html` — `<section id="sobre">`
- Modify: `styles.css`

**Interfaces:**
- Consumes: `.container`, `.pendente`.
- Produces: `.fundo-claro` (classe explícita que substitui a regra `nth-of-type`), `.sobre`, `.credenciais`.

- [ ] **Step 1: Corrigir o fundo alternado antes de continuar**

A regra `section:nth-of-type(even)` da Task 1 entra em conflito com os fundos explícitos de `.hero` e `.incomodo` — a alternância passa a depender da ordem no DOM e quebra sempre que uma seção for inserida no meio. Trocar por uma classe explícita.

Remover de `styles.css`:

```css
section:nth-of-type(even) { background: var(--cinza-fundo); }
```

E adicionar:

```css
.fundo-claro { background: var(--cinza-fundo); }
```

Depois, em `index.html`, trocar `<section class="incomodo">` por `<section class="incomodo fundo-claro">` e remover a linha `background: var(--cinza-fundo);` de dentro da regra `.incomodo` no CSS.

- [ ] **Step 2: Escrever a seção Sobre**

Substituir `<section id="sobre"></section>` por:

```html
<section id="sobre" class="sobre">
  <div class="container">
    <h2>Sobre o Dr. Geraldo</h2>

    <p>
      Sou médico formado <span class="pendente">[PENDENTE: faculdade e ano]</span>,
      com atuação voltada a obesidade, tireoide, hormônios e metabolismo.
      Atendo em Vila Velha há <span class="pendente">[PENDENTE: tempo de atuação]</span>.
    </p>

    <p>
      Aprendi cedo que a parte mais importante do que eu levo para uma consulta
      não é a receita — é a explicação. Quem entende o que está acontecendo com o
      próprio corpo trata melhor, erra menos e desiste menos no meio do caminho.
    </p>

    <p>
      Por isso minha consulta é longa. Prefiro atender menos gente por dia e sair
      de cada atendimento com a certeza de que a pessoa entendeu o que tem,
      por que tem, e o que vamos fazer a respeito.
    </p>

    <ul class="credenciais">
      <li><strong>CRM-ES 10212</strong></li>
      <li>Atuação em endocrinologia e metabologia</li>
      <li class="pendente">[PENDENTE: residência médica]</li>
      <li class="pendente">[PENDENTE: sociedades e títulos]</li>
    </ul>
  </div>
</section>
```

Observações de redação, para quem for ajustar o texto depois:
- Primeira pessoa é escolha deliberada da spec — aproxima e é coerente com o diferencial dele.
- "Prefiro atender menos gente por dia" prepara a explicação do atraso na Task 5. Não remover.
- Não usar a palavra proibida "endocrinologista" aqui; "atuação em endocrinologia e metabologia" é a construção correta.

- [ ] **Step 3: Estilizar**

```css
.credenciais {
  list-style: none; padding: 0; margin: 2rem 0 0;
  display: grid; gap: .55rem;
  max-width: var(--medida);
}
.credenciais li {
  padding-inline-start: 1.4rem;
  position: relative;
}
.credenciais li::before {
  content: ""; position: absolute; inset-inline-start: 0; top: .72em;
  width: .5rem; height: .5rem; border-radius: 50%;
  background: var(--azul-claro);
}
```

- [ ] **Step 4: Fazer as âncoras pararem abaixo do cabeçalho fixo**

A navegação é `sticky`. Sem compensação, clicar em "Sobre" leva o título da seção para
**debaixo** da barra — o leitor aterrissa num texto sem título. O valor não pode ser fixo:
a barra tem 66px no desktop e 124px no mobile, onde a navegação quebra em duas linhas.

Em `styles.css`, acrescentar `--nav-h` ao `:root`, logo após `--secao-y`:

```css
  --nav-h: 4.75rem;
```

Logo após a regra `box-sizing`:

```css
/* O cabeçalho é sticky: âncoras precisam parar abaixo dele, senão o título
   da seção fica escondido atrás da barra. O valor acompanha --nav-h, que
   muda no mobile porque a navegação passa a ocupar duas linhas. */
html { scroll-padding-top: calc(var(--nav-h) + 1.25rem); }
```

E uma media query própria para a altura — **959px, não 860px**. A barra quebra em duas
linhas bem antes do breakpoint de layout: o botão de WhatsApp só volta para a linha dos
links a partir de 960px. Usar 860px aqui deixa o `scroll-padding` cerca de 28px curto em
toda a faixa 861–959px:

```css
@media (max-width: 959px) { :root { --nav-h: 8.25rem; } }
```

Acrescentar também `role="list"` ao `<ul class="credenciais">`. O `list-style: none` remove a
semântica de lista em alguns leitores de tela; o atributo devolve, e custa nada.

- [ ] **Step 5: Rodar a verificação**

```bash
./verify.sh
```

Esperado: passa inteiro. Conferir em 360px e em 1280px que, ao clicar em cada link do menu,
o topo da seção de destino fica abaixo da barra. Medir também em **900px**, dentro da faixa
onde a barra quebra mas o layout ainda é de desktop — é onde o erro se esconde.

- [ ] **Step 5: Confirmar que as pendências estão visíveis**

```bash
grep -c 'class="pendente"' index.html
```

Esperado: `4`. Abrir no navegador e confirmar que aparecem com fundo amarelo e sublinhado tracejado — elas precisam ser óbvias na apresentação.

- [ ] **Step 6: Commit**

```bash
git add index.html styles.css
git commit -m "feat: seção sobre o médico, em primeira pessoa"
```

---

### Task 5: Como é a consulta

A seção mais estratégica do site. Nenhum dos quatro concorrentes analisados descreve o próprio processo de consulta.

**Files:**
- Modify: `index.html` — `<section id="consulta">`
- Modify: `styles.css`

**Interfaces:**
- Consumes: `.container`, `.fundo-claro`.
- Produces: `.passos`, `.passo`, `.nota-honesta`.

- [ ] **Step 1: Escrever a seção**

Substituir `<section id="consulta"></section>` por:

```html
<section id="consulta" class="consulta fundo-claro">
  <div class="container">
    <h2>Como é a consulta</h2>
    <p class="consulta__intro">
      Quatro etapas. Nenhuma delas tem hora marcada para acabar.
    </p>

    <ol class="passos">
      <li class="passo">
        <h3>1. A conversa</h3>
        <p>
          Começamos pela sua história: quando o peso mudou, como você dorme,
          o que já tentou, o que deu errado e o que você sentiu em cada tentativa.
          Sem cronômetro e sem questionário pronto.
        </p>
      </li>
      <li class="passo">
        <h3>2. Avaliação e exames</h3>
        <p>
          Examino você e peço os exames que fazem sentido para o seu caso —
          e explico por que estou pedindo cada um deles. Você não vai sair daqui
          com uma lista de siglas que não entende.
        </p>
      </li>
      <li class="passo">
        <h3>3. O plano</h3>
        <p>
          Monto o plano com você, não para você. Explico o que cada parte faz,
          o que esperar e em quanto tempo. Se você sair com dúvida,
          eu não terminei o meu trabalho.
        </p>
      </li>
      <li class="passo">
        <h3>4. O acompanhamento</h3>
        <p>
          Corpo muda, e plano bom muda junto. Nos retornos a gente revisa
          o que funcionou, o que não funcionou e ajusta o caminho.
        </p>
      </li>
    </ol>

    <div class="nota-honesta">
      <h3>Por que a minha agenda às vezes atrasa</h3>
      <p>
        Você provavelmente vai ler isso nas avaliações sobre mim,
        então prefiro dizer antes: às vezes eu atraso.
      </p>
      <p>
        O motivo é simples. Eu não encerro uma consulta porque o horário acabou.
        Se a pessoa que está na sala ainda tem dúvida, eu fico.
      </p>
      <p><strong>Quando for a sua vez, o mesmo vale para você.</strong></p>
    </div>
  </div>
</section>
```

Essa nota final é intencional: a única crítica recorrente nas 13 avaliações é a espera. Em vez de esconder, o texto usa a fraqueza como prova da tese do site. **Não suavizar nem remover.**

- [ ] **Step 2: Estilizar**

```css
.consulta__intro { font-size: 1.08rem; margin-bottom: 2.5rem; }

.passos {
  list-style: none; padding: 0; margin: 0;
  display: grid; gap: 1.25rem;
  /* Colunas explícitas, não auto-fit: com 4 itens e o container travado em 68rem,
     o auto-fit resolve para 3 colunas e deixa o quarto passo órfão. */
  grid-template-columns: 1fr;
}
@media (min-width: 640px)  { .passos { grid-template-columns: repeat(2, 1fr); } }
@media (min-width: 1100px) { .passos { grid-template-columns: repeat(4, 1fr); } }
.passo {
  background: var(--branco);
  border: 1px solid var(--borda);
  border-radius: 10px;
  padding: 1.5rem;
}
.passo h3 { margin-bottom: .6rem; }
.passo p { margin: 0; font-size: .98rem; }

.nota-honesta {
  margin-top: 2.5rem;
  border-inline-start: 4px solid var(--azul-claro);
  background: var(--branco);
  border-radius: 0 10px 10px 0;
  padding: 1.75rem 1.75rem 1.25rem;
}
.nota-honesta h3 { margin-bottom: .8rem; }
```

- [ ] **Step 3: Rodar a verificação**

```bash
./verify.sh
```

Esperado: mesma falha única do CRM.

- [ ] **Step 4: Commit**

```bash
git add index.html styles.css
git commit -m "feat: seção detalhando o processo de consulta"
```

---

### Task 6: O que eu trato

**Files:**
- Modify: `index.html` — `<section id="trato">`
- Modify: `styles.css`

**Interfaces:**
- Consumes: `.container`.
- Produces: `.temas`, `.tema`, `.tema__limite`.

Cada bloco segue a mesma estrutura de três partes: o que é, o que fazemos, o que **não** se promete. A terceira parte não é modéstia — é o que mantém o texto dentro das regras de publicidade médica e, ao mesmo tempo, é o que soa mais confiável para o leitor.

- [ ] **Step 1: Escrever a seção**

Substituir `<section id="trato"></section>` por:

```html
<section id="trato" class="trato">
  <div class="container">
    <h2>O que eu trato</h2>

    <div class="temas">
      <article class="tema">
        <h3>Obesidade e emagrecimento</h3>
        <p>
          Obesidade é doença crônica, não falta de força de vontade. A genética
          responde por boa parte da facilidade — ou da dificuldade — que cada
          pessoa tem para ganhar e perder peso. Isso não quer dizer que não há
          o que fazer. Quer dizer que culpa nunca foi tratamento.
        </p>
        <p>
          <strong>O que fazemos:</strong> investigar o que está sustentando o peso
          no seu caso — hormônios, sono, remédios que você já usa, histórico de
          dietas — e montar um plano que caiba na sua vida real.
        </p>
        <p class="tema__limite">
          <strong>O que eu não prometo:</strong> número na balança, prazo,
          nem resultado igual ao de outra pessoa.
        </p>
      </article>

      <article class="tema">
        <h3>Tireoide e hormônios</h3>
        <p>
          Cansaço que não passa, queda de cabelo, sentir frio o tempo todo,
          humor oscilando, ciclo irregular. São sintomas inespecíficos — ou seja,
          podem vir de muitas causas diferentes — e é por isso que tanta gente
          circula entre especialidades sem sair com uma resposta.
        </p>
        <p>
          <strong>O que fazemos:</strong> ler os seus exames dentro do seu contexto,
          e não isoladamente. Um resultado "dentro da faixa de referência"
          nem sempre é o resultado certo para você.
        </p>
        <p class="tema__limite">
          <strong>O que eu não prometo:</strong> que todo sintoma tem origem hormonal.
          Às vezes a resposta está em outro lugar, e dizer isso também é parte
          do meu trabalho.
        </p>
      </article>

      <article class="tema">
        <h3>Composição corporal</h3>
        <p>
          Peso, sozinho, diz pouco. Duas pessoas com o mesmo número na balança
          podem ter corpos metabolicamente muito diferentes — proporções
          distintas de músculo, gordura e água.
        </p>
        <p>
          <strong>O que fazemos:</strong> avaliar composição corporal, rotina de
          treino, alimentação e exames, e orientar ganho de massa e desempenho
          com base clínica.
        </p>
        <p class="tema__limite">
          <strong>O que eu não prometo:</strong> atalho, resultado estético garantido,
          nem uso de qualquer substância fora de indicação médica.
        </p>
      </article>
    </div>
  </div>
</section>
```

A última linha do terceiro bloco é a mais importante do ponto de vista ético — composição corporal é o tema mais sensível em publicidade médica. **Não remover.**

- [ ] **Step 2: Estilizar**

```css
.temas {
  display: grid; gap: 1.5rem;
  /* Três itens: só 1 ou 3 colunas evitam deixar um card órfão em meia largura.
     O auto-fit resolvia para 2 colunas entre 768px e 948px. */
  grid-template-columns: 1fr;
  margin-top: 2rem;
}
@media (min-width: 900px) { .temas { grid-template-columns: repeat(3, 1fr); } }
.tema {
  border: 1px solid var(--borda);
  border-radius: 10px;
  padding: 1.75rem;
  background: var(--branco);
}
.tema h3 { margin-bottom: .9rem; }
.tema p { font-size: .97rem; max-width: none; }
.tema__limite {
  margin: 1.1rem 0 0;
  padding-top: 1.1rem;
  border-top: 1px solid var(--borda);
  color: #5A6475;
  font-size: .92rem;
}
```

- [ ] **Step 3: Verificar contraste do texto atenuado**

O `#5A6475` sobre `#FFFFFF` precisa atingir AA (4.5:1). Conferir em https://webaim.org/resources/contrastchecker/ — a razão é 5,97:1, portanto passa. Se alguém escurecer o fundo do card depois, refazer essa conta.

- [ ] **Step 4: Rodar a verificação**

```bash
./verify.sh
```

Esperado: mesma falha única do CRM. Atenção especial ao resultado da linha `ausente: 'resultados garantidos'` — essa seção fala de promessas e é onde o erro seria mais provável.

- [ ] **Step 5: Commit**

```bash
git add index.html styles.css
git commit -m "feat: seção dos três temas clínicos, com limites explícitos"
```

---

### Task 7: Pacientes e Consultório

**Files:**
- Modify: `index.html` — `<section id="pacientes">` e `<section id="consultorio">`
- Modify: `styles.css`
- Create: `img/mapa-consultorio.png` (placeholder)

**Interfaces:**
- Consumes: `.container`, `.fundo-claro`, `.pendente`, `.cta`.
- Produces: `.depoimentos`, `.depoimento`, `.consultorio__grid`.

- [ ] **Step 1: Escrever a seção de depoimentos**

As quatro citações são reais, do perfil no Doctoralia, com data e crédito à fonte. Prova social de terceiro verificável é mais forte e mais defensável que texto sem origem.

Substituir `<section id="pacientes"></section>` por:

```html
<section id="pacientes" class="pacientes fundo-claro">
  <div class="container">
    <h2>O que dizem os pacientes</h2>
    <p>
      Avaliações publicadas por pacientes no Doctoralia, reproduzidas aqui
      com a data original.
    </p>

    <div class="depoimentos">
      <blockquote class="depoimento">
        <p>"Explica as coisas olhando nos seus olhos."</p>
        <footer>Paciente anônimo · novembro de 2018</footer>
      </blockquote>

      <blockquote class="depoimento">
        <p>"Você sai do consultório sem nenhuma dúvida."</p>
        <footer>Paciente anônimo · janeiro de 2017</footer>
      </blockquote>

      <blockquote class="depoimento">
        <p>"Demorou um pouco, mas valeu a pena esperar. Médico atencioso e simpático."</p>
        <footer>Paciente anônimo · junho de 2017</footer>
      </blockquote>

      <blockquote class="depoimento">
        <p>"Entendeu minhas necessidades e montou um plano de ação adequado."</p>
        <footer>Fabiano de Paula · agosto de 2023</footer>
      </blockquote>
    </div>

    <p>
      <a href="https://www.doctoralia.com.br/geraldo-andrade-do-norte/generalista/vila-velha"
         rel="noopener">Ler as 13 avaliações no Doctoralia</a>
    </p>
  </div>
</section>
```

**Item aberto herdado da spec:** validar com o CRM-ES se a reprodução de depoimento de paciente é permitida em publicidade médica antes de publicar. Se houver vedação, remover as quatro citações e deixar apenas o link para o perfil. A estrutura foi montada para que essa remoção seja trivial.

- [ ] **Step 2: Gerar o placeholder do mapa**

```bash
# placeholder SVG válido, mesmo padrão da foto (ver Task 3)
```

Imagem estática, nunca `iframe` do Google Maps — evita cookie de terceiro (a spec resolve LGPD por arquitetura) e evita o peso de carregamento.

- [ ] **Step 3: Escrever a seção do consultório**

Substituir `<section id="consultorio"></section>` por:

```html
<section id="consultorio" class="consultorio">
  <div class="container consultorio__grid">
    <div>
      <h2>O consultório</h2>

      <p>
        <strong>Endereço</strong><br>
        <span class="pendente">[PENDENTE: endereço definitivo — o Doctoralia indica
        R. Humberto Serrano; a clínica IMI fica em Itapoã. Confirmar qual é o
        endereço de atendimento]</span><br>
        Vila Velha — ES
      </p>

      <p>
        <strong>Horário de atendimento</strong><br>
        <span class="pendente">[PENDENTE: dias e horários]</span>
      </p>

      <p>
        <strong>Como marcar</strong><br>
        O agendamento é feito pela secretária, por WhatsApp.
      </p>

      <a class="cta" href="https://wa.me/5527000000000" target="_blank" rel="noopener">
        Falar com a secretária no WhatsApp
      </a>
    </div>

    <a href="https://maps.google.com/?q=Vila+Velha+ES" rel="noopener">
      <img src="img/mapa-consultorio.svg"
           alt="Localização do consultório em Vila Velha — mapa provisório; abre no Google Maps"
           width="640" height="480">
    </a>
  </div>
</section>
```

- [ ] **Step 4: Estilizar**

```css
.depoimentos {
  display: grid; gap: 1.25rem;
  /* Mesmo motivo de .passos: 4 itens com auto-fit resolvem para 3 colunas
     dentro do container de 68rem e deixam o quarto depoimento órfão. */
  grid-template-columns: 1fr;
  margin: 2rem 0;
}
@media (min-width: 640px)  { .depoimentos { grid-template-columns: repeat(2, 1fr); } }
@media (min-width: 1100px) { .depoimentos { grid-template-columns: repeat(4, 1fr); } }
.depoimento {
  margin: 0;
  background: var(--branco);
  border: 1px solid var(--borda);
  border-radius: 10px;
  padding: 1.5rem;
}
.depoimento p {
  font-family: var(--fonte-titulo);
  font-size: 1.08rem;
  color: var(--azul-institucional);
  margin: 0 0 .9rem;
  max-width: none;
}
.depoimento footer {
  font-style: normal;
  font-size: .84rem;
  color: #5A6475;
}

.consultorio__grid {
  display: grid; gap: 2.5rem;
  grid-template-columns: 1fr 1fr;
  align-items: start;
}
.consultorio__grid img { border-radius: 10px; border: 1px solid var(--borda); }

@media (max-width: 820px) {
  .consultorio__grid { grid-template-columns: 1fr; }
}
```

- [ ] **Step 5: Rodar a verificação**

```bash
./verify.sh
```

Esperado: duas imagens agora, ambas com `alt` — a checagem passa. Segue falhando só o CRM.

- [ ] **Step 6: Commit**

```bash
git add index.html styles.css img/mapa-consultorio.svg
git commit -m "feat: depoimentos creditados e seção do consultório"
```

---

### Task 8: Dúvidas frequentes e rodapé

**Files:**
- Modify: `index.html` — `<section id="duvidas">` e `<footer>`
- Modify: `styles.css`

**Interfaces:**
- Consumes: `.container`, `.fundo-claro`, `.pendente`.
- Produces: `.duvidas`, `.rodape`. **Esta task faz o `verify.sh` passar por completo** ao inserir a segunda ocorrência de `CRM-ES 10212`.

- [ ] **Step 1: Escrever as dúvidas com `<details>` nativo**

Substituir `<section id="duvidas"></section>` por:

```html
<section id="duvidas" class="duvidas fundo-claro">
  <div class="container">
    <h2>Dúvidas frequentes</h2>

    <details>
      <summary>Você atende convênio?</summary>
      <p>
        Não. O atendimento é exclusivamente particular. É essa escolha que me
        permite manter a consulta longa e receber menos pacientes por dia —
        se eu atendesse por convênio, precisaria fazer o contrário dos dois.
      </p>
    </details>

    <details>
      <summary>Você atende online?</summary>
      <p class="pendente">
        [PENDENTE: confirmar se há atendimento por telemedicina]
      </p>
    </details>

    <details>
      <summary>Preciso levar exames na primeira consulta?</summary>
      <p>
        Se você tiver exames, leve — mesmo os antigos. Exames de anos anteriores
        mostram como o seu corpo mudou ao longo do tempo, e isso costuma valer
        mais do que um exame isolado de agora. Se não tiver nenhum, tudo bem:
        a gente pede na consulta.
      </p>
    </details>

    <details>
      <summary>Quanto tempo dura a consulta?</summary>
      <p>
        A primeira é a mais longa, porque é onde a sua história inteira é
        levantada. Não trabalho com tempo fixo por paciente.
      </p>
    </details>

    <details>
      <summary>Você trata só emagrecimento?</summary>
      <p>
        Não. Obesidade é a procura mais comum, mas o atendimento cobre tireoide,
        alterações hormonais e questões de metabolismo em geral.
      </p>
    </details>

    <details>
      <summary>Como marco uma consulta?</summary>
      <p>
        Pelo WhatsApp da secretária. É o canal mais rápido, e por ele você
        já recebe as orientações do que levar.
      </p>
    </details>
  </div>
</section>
```

A primeira pergunta é a mais importante. Ele é 100% particular, e isso aparece nas avaliações como a única frustração real dos pacientes. Declarar de frente evita paciente irritado ligando à toa, poupa a secretária, e converte a objeção em argumento.

- [ ] **Step 2: Escrever o rodapé**

Substituir `<footer></footer>` por:

```html
<footer class="rodape">
  <div class="container rodape__grid">
    <div>
      <strong class="rodape__marca">Dr. Geraldo Andrade do Norte</strong>
      <p>CRM-ES 10212<br>Vila Velha — ES</p>
    </div>
    <div>
      <p>
        <a href="https://wa.me/5527000000000" target="_blank" rel="noopener">WhatsApp da secretária</a><br>
        <a href="https://www.doctoralia.com.br/geraldo-andrade-do-norte/generalista/vila-velha"
           rel="noopener">Perfil no Doctoralia</a>
      </p>
    </div>
    <p class="rodape__aviso">
      Este site tem caráter informativo e não substitui uma consulta médica.
      Procure atendimento para avaliação do seu caso.
    </p>
  </div>
</footer>
```

- [ ] **Step 3: Estilizar**

```css
.duvidas details {
  background: var(--branco);
  border: 1px solid var(--borda);
  border-radius: 8px;
  padding: 1rem 1.25rem;
  margin-bottom: .75rem;
  max-width: var(--medida);
}
.duvidas summary {
  cursor: pointer;
  font-weight: 600;
  color: var(--azul-institucional);
}
.duvidas details[open] summary { margin-bottom: .75rem; }
.duvidas details p { margin: 0; font-size: .97rem; }

.rodape {
  background: var(--azul-institucional);
  color: #D8E0F2;
  padding-block: 3rem 2rem;
}
.rodape a { color: var(--branco); }
/* O anel de foco global usa --azul-acao, calibrado para fundo claro: sobre o
   azul institucional do rodapé ele cai para 1,85:1 e some. Branco dá 9,69:1. */
.rodape a:focus-visible { outline-color: var(--branco); }
.rodape__grid {
  display: grid; gap: 2rem;
  /* Só dois filhos ocupam coluna (o terceiro atravessa a linha), então o
     auto-fit abria até 4 colunas e deixava metade da linha vazia. */
  grid-template-columns: 1fr;
}
@media (min-width: 640px) { .rodape__grid { grid-template-columns: repeat(2, 1fr); } }
.rodape__marca {
  font-family: var(--fonte-titulo);
  font-size: 1.1rem;
  color: var(--branco);
  display: block;
  margin-bottom: .5rem;
}
.rodape__aviso {
  grid-column: 1 / -1;
  border-top: 1px solid rgba(255,255,255,.2);
  padding-top: 1.25rem;
  font-size: .85rem;
  max-width: none;
}
```

- [ ] **Step 4: Rodar a verificação — agora tem que passar inteira**

```bash
./verify.sh
```

Esperado: **"Tudo passou."** com código de saída 0. Esse é o marco verde do plano. Se o CRM ainda acusar 1 ocorrência, o rodapé não foi inserido corretamente.

- [ ] **Step 5: Commit**

```bash
git add index.html styles.css
git commit -m "feat: dúvidas frequentes sem JavaScript e rodapé com aviso legal"
```

---

### Task 9: Responsividade, acessibilidade e performance

**Files:**
- Modify: `styles.css`
- Modify: `verify.sh` — acrescentar duas checagens

**Interfaces:**
- Consumes: tudo que foi construído.
- Produces: `verify.sh` com as checagens de pendência e de hierarquia de títulos.

- [ ] **Step 1: Acrescentar as duas últimas checagens ao `verify.sh`**

Inserir antes do bloco final que imprime o resultado:

```bash
# --- Pendências continuam marcadas ---
pend=$(grep -c 'class="pendente"' index.html)
if [ "$pend" -ge 7 ]; then
  ok "pendências marcadas: $pend"
else
  falha "só $pend pendências marcadas, esperado no mínimo 7"
fi

# --- Um único h1 ---
h1=$(grep -o '<h1' index.html | wc -l | tr -d ' ')
if [ "$h1" -eq 1 ]; then
  ok "exatamente um <h1>"
else
  falha "$h1 tags <h1>, esperado exatamente 1"
fi
```

- [ ] **Step 2: Rodar e confirmar que as novas checagens passam**

```bash
./verify.sh
```

Esperado: "Tudo passou." Se a contagem de pendências vier abaixo de 7, alguma pendência foi preenchida ou perdeu a marcação — conferir contra a tabela da seção 11 da spec.

- [ ] **Step 3: Acrescentar respeito a `prefers-reduced-motion` e melhorar o alvo de toque**

```css
html { scroll-behavior: smooth; }

@media (prefers-reduced-motion: reduce) {
  html { scroll-behavior: auto; }
  *, *::before, *::after {
    animation-duration: .01ms !important;
    transition-duration: .01ms !important;
  }
}

/* Alvo de toque mínimo de 44px nos links de navegação e no FAQ.
   A caixa clicável do `summary` mede 30,6px (18px × line-height 1,7), então
   `.35rem` de cada lado ainda deixaria em 42px. `.5rem` leva a 46,6px. */
@media (pointer: coarse) {
  .nav__links a { padding-block: .7rem; }
  .duvidas summary { padding-block: .5rem; }
}
```

O `scroll-padding-top` **não** entra aqui: foi antecipado para a Task 4, porque o defeito se manifesta assim que a primeira seção ancorável ganha conteúdo. Ver Task 4, Step 4.

- [ ] **Step 4: Conferir em três larguras**

```bash
open index.html
```

Testar em 360px, 768px e 1280px. Confirmar em cada uma: nada estoura horizontalmente; a foto da abertura aparece acima do texto no mobile; os cards de tema e de passo empilham; o mapa vai para baixo do endereço.

- [ ] **Step 5: Rodar Lighthouse**

```bash
npx --yes lighthouse index.html --quiet --chrome-flags="--headless" --only-categories=performance,accessibility,best-practices,seo --output=json --output-path=/tmp/lh.json && node -e "const r=require('/tmp/lh.json');for(const k in r.categories)console.log(k, Math.round(r.categories[k].score*100))"
```

Esperado: quatro categorias com 95 ou mais. Se Performance ficar abaixo, a causa mais provável é a imagem do retrato sem otimização — converter para WebP e reduzir para no máximo 800px de largura resolve. Se Acessibilidade ficar abaixo, ler os itens apontados; os suspeitos são contraste e ordem de títulos.

- [ ] **Step 6: Commit**

```bash
git add styles.css verify.sh
git commit -m "test: checagens de pendência e h1; a11y e responsividade"
```

---

### Task 10: Deploy da apresentação

**Files:**
- Create: `vercel.json`
- Create: `README.md`

**Interfaces:**
- Consumes: o site completo e verificado.
- Produces: uma URL pública temporária para a apresentação ao Dr. Geraldo.

- [ ] **Step 1: Criar a configuração de deploy estático**

`vercel.json`:

```json
{
  "$schema": "https://openapi.vercel.sh/vercel.json",
  "cleanUrls": true,
  "headers": [
    {
      "source": "/img/(.*)",
      "headers": [
        { "key": "Cache-Control", "value": "public, max-age=31536000, immutable" }
      ]
    }
  ]
}
```

Sem `buildCommand` e sem `framework`: é HTML estático, a Vercel serve o diretório como está.

**Por que `vercel.json` e não `vercel.ts`.** O `vercel.ts` é hoje a forma recomendada de
configurar projetos na Vercel, mas ele exige instalar `@vercel/config` — ou seja, um
`package.json`, um `node_modules` e uma etapa de build num projeto que foi deliberadamente
desenhado para não ter nenhuma das três coisas. Para sete regras de cabeçalho HTTP, o JSON
resolve sem introduzir dependência. Se o projeto um dia ganhar build, reavaliar.

- [ ] **Step 2: Escrever o README com o estado do projeto**

`README.md`:

```markdown
# Site Dr. Geraldo Andrade do Norte

Peça de apresentação (v1) para aprovação do projeto.

- Especificação: `docs/superpowers/specs/2026-09-11-site-dr-geraldo-design.md`
- Plano: `docs/superpowers/plans/2026-09-11-site-dr-geraldo.md`

## Verificar

    ./verify.sh

Checa: ausência de JavaScript, palavras proibidas, presença do CRM, seções
obrigatórias, `alt` nas imagens, metadados e pendências marcadas.

## Pendências antes de publicar

1. Fotos profissionais
2. Bio e formação
3. Confirmação de RQE
4. WhatsApp correto
5. Endereço definitivo (conflito entre Doctoralia e IMI)
6. Horário de atendimento
7. Autorização para usar as cores do IMI
8. Validar depoimentos junto ao CRM-ES

## Aviso

Este é material estático sem coleta de dados: sem formulário, sem cookie,
sem analytics.
```

- [ ] **Step 3: Instalar a CLI da Vercel**

A CLI não está instalada nesta máquina.

```bash
npm i -g vercel && vercel --version
```

- [ ] **Step 4: Rodar a verificação uma última vez antes de publicar**

```bash
./verify.sh
```

Esperado: "Tudo passou." **Não publicar com falha.**

- [ ] **Step 5: Publicar**

```bash
vercel deploy --yes
```

`vercel deploy` sem `--prod` cria um deploy de **preview**. O `--yes` evita que a CLI fique
presa num prompt interativo. Deploy de preview, não de produção — é material de um cliente que ainda não aprovou nada. A URL de preview é suficiente para a apresentação.

- [ ] **Step 6: Conferir o preview de compartilhamento**

Abrir a URL gerada em https://www.opengraph.xyz/ e confirmar que título, descrição e imagem aparecem. Esse preview é a primeira coisa que o Dr. Geraldo vai ver quando o link chegar no WhatsApp dele.

- [ ] **Step 7: Commit**

```bash
git add vercel.json README.md
git commit -m "chore: configuração de deploy estático e README do projeto"
```

---

## Cobertura da especificação

| Seção da spec | Onde é implementada |
|---|---|
| 6.1 Navegação fixa | Task 2 |
| 6.2 Abertura | Task 3 |
| 6.3 O incômodo | Task 3 |
| 6.4 Sobre | Task 4 |
| 6.5 Como é a consulta | Task 5 |
| 6.6 O que eu trato | Task 6 |
| 6.7 Depoimentos | Task 7 |
| 6.8 Consultório | Task 7 |
| 6.9 Dúvidas frequentes | Task 8 |
| 6.10 Rodapé | Task 8 |
| 7 Identidade visual | Task 1 (tokens), refinada em cada task |
| 8 Decisões técnicas | Task 1 (head, JSON-LD, OG), Task 9 (performance) |
| 9 Conformidade CFM | Constraints globais, `verify.sh`, Tasks 6 e 8 |
| 9 LGPD | Por arquitetura — nenhuma task introduz coleta |
| 10 Regras de redação | `verify.sh` automatiza as regras 1 a 3 |
| 11 Pendências | Tasks 3, 4, 7, 8; contadas pelo `verify.sh` na Task 9 |
| 12 Critérios de aceite | `verify.sh` (Tasks 1 e 9) e Lighthouse (Task 9) |

## Nota sobre TDD neste projeto

Não há código executável para testar unitariamente: o site é HTML e CSS sem
JavaScript, por decisão da spec. O ciclo vermelho-verde é preservado pelo
`verify.sh`, escrito **antes** do `index.html` na Task 1 e executado ao final de
cada task. Ele automatiza os critérios de aceite da seção 12 da spec — inclusive
as regras de redação, que são a parte do projeto onde o erro humano é mais provável
e mais caro.
