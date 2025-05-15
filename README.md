# Login App Flutter

Este projeto é uma aplicação Flutter com splash screen nativa e animada, onboarding com múltiplas páginas, login funcional com armazenamento de usuário, suporte a tema claro/escuro e widgets reutilizáveis.

---

## Fluxo da Aplicação

1. **Splash Screen Nativa**
   Criada com o pacote `flutter_native_splash`, exibida ao abrir o app.

2. **Splash Animada**
   Após a splash nativa, uma splash com animação `Lottie` é exibida.

3. **Onboarding**
   3 telas com imagem + texto informativo. O botão "Vamos começar" leva à tela de login.

4. **Login**
   Contém campos de e-mail e senha com validação, opção de lembrar usuário, e navegação para:

   * Tela principal
   * Registro
   * Recuperar senha

5. **Tela Principal**
   Exibe mensagem de boas-vindas, botão para funcionalidade fictícia e botão para logout.

6. **Funcionalidade X**
   Tela fictícia com saudação personalizada.

---

## Pacotes Utilizados

* [`flutter_native_splash`](https://pub.dev/packages/flutter_native_splash) → Splash screen nativa
* [`shared_preferences`](https://pub.dev/packages/shared_preferences) → Lembrar usuário logado
* [`lottie`](https://pub.dev/packages/lottie) → Animação da splash
* [`sqflite`](https://pub.dev/packages/sqflite) → Armazenamento local dos usuários
* [`path_provider`](https://pub.dev/packages/path_provider) → Caminho para o banco SQLite
* [`flutter_localizations`](https://docs.flutter.dev/ui/accessibility-and-internationalization/internationalization) → Suporte multilíngue (PT/EN)

---

## Tema Claro/Escuro

O app possui temas em `light_theme.dart` e `dark_theme.dart`, alternáveis em tempo real via ícone na `AppBar`, controlado com `ThemeController` e `ValueNotifier`.

---

## Widgets Customizados

* **LoginTextFormField**: Campo de formulário com foco, validação e reutilização.
* **CustomCardWidget**: Cabeçalho decorativo reutilizável exibido na tela de login.

---


## Como Executar

1. Clone o repositório:

```
git clone https://github.com/SEU_USUARIO/login_app_flutter.git
cd login_app_flutter
```

2. Instale as dependências:

```
flutter pub get
```

3. Gere os arquivos de localização (caso use i18n):

```
flutter gen-l10n
```

4. Execute o projeto:

```
flutter run
```
---

Desenvolvido por \[Seu Nome], UTFPR – 2025.

