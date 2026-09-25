# Site Dr. Geraldo Andrade do Norte

Peça de apresentação (v1) para aprovação do projeto pelo cliente.
Página única, HTML e CSS puros, **zero JavaScript**, sem build, sem dependências e
sem nenhuma requisição externa — as fontes são servidas de `fonts/`.

- Especificação: `docs/superpowers/specs/2026-09-11-site-dr-geraldo-design.md`
- Plano: `docs/superpowers/plans/2026-09-11-site-dr-geraldo.md`

## Rodar local

    python3 -m http.server 8770 --bind 127.0.0.1

Abrir <http://127.0.0.1:8770>. O navegador guarda HTML e CSS em cache — ao conferir
alterações, use um parâmetro novo na URL (`?v=2`) ou force a recarga.

## Verificar

    ./verify.sh

Checa ausência de JavaScript, palavras proibidas, presença do CRM, seções obrigatórias,
`alt` nas imagens, metadados, marcadores de pendência e `<h1>` único.

Lighthouse medido em 2026-09-24: **100 / 100 / 100 / 100**
(performance, acessibilidade, boas práticas, SEO). O Lighthouse exige URL servida,
não caminho de arquivo:

    npx --yes lighthouse http://127.0.0.1:8770/index.html --chrome-flags="--headless=new"

## Pendências antes de publicar

1. Fotos profissionais do médico — o retrato da abertura é o único do site.
   Se houver uma segunda foto, ela cabe na seção "Sobre".
2. Bio e formação (faculdade, ano, residência, sociedades)
3. Confirmação de RQE — sem ele, o site não pode chamá-lo de endocrinologista
4. Número de WhatsApp correto
5. Endereço definitivo — conflito entre Doctoralia e a clínica IMI
6. Horário de atendimento
7. Confirmar se há atendimento por telemedicina
8. Autorização para usar as cores do IMI
9. Validar com o CRM-ES a reprodução de depoimentos de pacientes
10. Consentimento do paciente nomeado no quarto depoimento
11. Trocar `og:image` para URL absoluta quando o domínio existir

## Privacidade

Sem formulário, sem banco, sem cookie, sem analytics. O site não coleta dado nenhum.
