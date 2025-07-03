# ✨ My Tasks

Um gerenciador de tarefas e eventos pessoais com calendário interativo, construído com Flutter. O projeto inclui um fluxo de autenticação completo, armazenamento de dados local com SQLite, e um sistema robusto para criação de eventos únicos e recorrentes.

---

## 🚀 Fluxo e Funcionalidades Principais

1.  **Splash Screen e Onboarding**
    * **Splash Nativa:** Criada com `flutter_native_splash` para uma inicialização rápida e visualmente agradável.
    * **Splash Animada:** Em seguida, uma tela com animação `Lottie` é exibida, proporcionando uma transição suave.
    * **Onboarding:** Um guia de 3 páginas apresenta o app ao usuário pela primeira vez.

2.  **Autenticação de Usuário**
    * **Login e Registro:** Sistema completo com validação de campos e armazenamento seguro de usuários no banco de dados local.
    * **Lembrar Usuário:** Utiliza `shared_preferences` para manter o usuário logado entre sessões.
    * **Recuperação de Senha:** Tela para o fluxo de recuperação de senha (UI implementada).

3.  **Dashboard (Tela Principal)**
    * Após o login, o usuário é direcionado para um painel de boas-vindas personalizado, com seu nome e avatar.
    * Apresenta dois botões de acesso rápido às funcionalidades principais: **Agenda** e **Novo Evento Recorrente**.

4.  **📅 Agenda Inteligente (`table_calendar`)**
    * **Visualização Completa:** Um calendário interativo exibe marcadores nos dias que possuem eventos.
    * **Lista de Eventos:** Ao selecionar um dia, uma lista com todos os eventos (únicos e recorrentes) daquela data é exibida.
    * **Gerenciamento de Eventos Únicos (CRUD):**
        * **Criação:** Adicione eventos para uma data específica.
        * **Edição e Exclusão:** Toque em um evento para abrir um diálogo com opções de editar ou excluir, incluindo uma confirmação para evitar ações acidentais.
    * **Gerenciamento de Eventos Recorrentes (CRUD):**
        * **Criação de Regras:** Crie eventos que se repetem em dias específicos da semana (ex: academia toda segunda, quarta e sexta) dentro de um intervalo de datas.
        * **Edição e Exclusão de Regras:** O sistema permite editar ou excluir a regra de recorrência, afetando todas as futuras ocorrências do evento.

5.  **👥 Perfil de Usuário Editável**
    * O usuário pode tocar em seu avatar no dashboard para navegar até a tela de edição de perfil.
    * É possível **alterar o nome e a senha**. O e-mail permanece fixo como identificador único.
    * A `HomeScreen` utiliza `StatefulWidget` para refletir as alterações de nome instantaneamente após salvar.

---

## 🏗️ Arquitetura e Componentes Reutilizáveis

* **Gerenciamento de Estado:** O projeto utiliza `StatefulWidget` com `setState` e `ValueNotifier` para um gerenciamento de estado simples e eficiente, ideal para a escala da aplicação.
* **Banco de Dados:** O `SQFlite` é gerenciado através de uma classe centralizada `DatabaseService` (Padrão Singleton), que previne conflitos e garante um único ponto de acesso ao banco.
* **DAO (Data Access Object):** A lógica de acesso a dados é claramente separada em DAOs (`UserDao`, `EventDao`, `RecurringEventDao`), promovendo um código mais limpo e organizado.
* **Reutilização de UI:** A tela `AddRecurringEventScreen` foi adaptada para funcionar tanto para **criação** quanto para **edição** de regras, uma prática que evita duplicação de código.

---

## 📦 Pacotes Utilizados

* [`flutter_native_splash`](https://pub.dev/packages/flutter_native_splash): Splash screen nativa.
* [`shared_preferences`](https://pub.dev/packages/shared_preferences): Armazenamento simples para lembrar o usuário logado.
* [`lottie`](https://pub.dev/packages/lottie): Animações vetoriais.
* [`sqflite`](https://pub.dev/packages/sqflite): Banco de dados SQL local.
* [`path`](https://pub.dev/packages/path): Manipulação de caminhos de arquivos do sistema.
* [`table_calendar`](https://pub.dev/packages/table_calendar): Widget de calendário completo e customizável.
* [`intl`](https://pub.dev/packages/intl): Para internacionalização e formatação de datas (usado pelo `table_calendar`).
* `flutter_localizations`: Suporte a múltiplos idiomas (configurado para `pt_BR`).

---

## 🎨 Tema Claro/Escuro

O app possui suporte completo a tema claro e escuro. A troca é feita em tempo real através de um ícone na `AppBar` e gerenciada pela classe `ThemeController`.

---

## 🚀 Como Executar

1.  Clone o repositório:
    ```bash
    git clone [https://github.com/SEU_USUARIO/my_tasks.git](https://github.com/SEU_USUARIO/my_tasks.git)
    cd my_tasks
    ```

2.  Instale as dependências:
    ```bash
    flutter pub get
    ```

3.  Execute o projeto:
    ```bash
    flutter run
    ```

---
