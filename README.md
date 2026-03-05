# BioMapa

Aplicativo móvel multiplataforma em Flutter para mapeamento biológico geolocalizado com arquitetura limpa, MVVM e integração Supabase.

## Funcionalidades principais

- Autenticação com email/senha e Google OAuth
- Registro de organismos com foto, localização automática e taxonomia
- Mapa interativo com marcadores por categoria e clusters
- Feed social de registros da comunidade
- Perfil com estatísticas, seguir/deixar de seguir e mensagens privadas
- Eventos de campo colaborativos
- Notificações personalizadas por categoria e raio
- Cache offline com sincronização automática
- Tema claro/escuro adaptativo

## Arquitetura

- `lib/core`: entidades compartilhadas e serviços transversais
- `lib/features/*/domain`: entidades, contratos de repositório e casos de uso
- `lib/features/*/data`: integração Supabase, cache local e serialização
- `lib/features/*/presentation`: páginas Flutter e ViewModels MVVM
- `lib/app`: tema, roteamento e composição da aplicação

## Configuração Supabase

Execute o app passando variáveis de ambiente:

```bash
flutter run --dart-define=SUPABASE_URL=SUA_URL --dart-define=SUPABASE_ANON_KEY=SUA_CHAVE
```

Para Google OAuth:

```bash
flutter run --dart-define=GOOGLE_WEB_CLIENT_ID=SEU_CLIENT_ID_WEB --dart-define=GOOGLE_IOS_CLIENT_ID=SEU_CLIENT_ID_IOS
```

## Estrutura mínima de tabelas no Supabase

- `organisms`
- `taxonomy_dictionary`
- `field_events`
- `messages`
- `follows`

Campos usados no app:

- `organisms`: `id`, `usuario_id`, `nome_popular`, `categoria`, `latitude`, `longitude`, `precisao_metros`, `fotos`, `criado_em`, `reino`, `filo`, `classe`, `ordem`, `familia`, `genero`, `especie`, `descricao`
- `taxonomy_dictionary`: `categoria`, `nome_cientifico`
- `field_events`: `id`, `titulo`, `descricao`, `organizador_id`, `latitude`, `longitude`, `data_hora`, `participantes_ids`
- `messages`: `remetente_id`, `destinatario_id`, `conteudo`
- `follows`: `follower_id`, `followed_id`

## Testes e cobertura

Executar testes:

```bash
flutter test
```

Gerar cobertura:

```bash
flutter test --coverage
```

A meta do projeto é cobertura mínima de 80% para regras de domínio e ViewModels.
