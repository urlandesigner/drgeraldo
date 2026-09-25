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

echo
if [ "$falhas" -eq 0 ]; then
  printf '\033[32mTudo passou.\033[0m\n'; exit 0
else
  printf '\033[31m%d falha(s).\033[0m\n' "$falhas"; exit 1
fi
