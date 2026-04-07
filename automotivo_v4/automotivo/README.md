# AutoSystem — Sistema de Gestão Automotiva

## Estrutura do projeto

```
automotivo/
├── backend/          ← API REST Spring Boot (Java 17)
│   ├── pom.xml
│   └── src/
│       └── main/
│           ├── java/com/example/automotivo/
│           │   ├── AutomotivoApplication.java
│           │   ├── config/CorsConfig.java
│           │   ├── controller/
│           │   │   ├── GlobalExceptionHandler.java
│           │   │   ├── UsuarioController.java
│           │   │   ├── ClienteController.java
│           │   │   ├── OficinaController.java
│           │   │   ├── OrdemServicoController.java
│           │   │   └── MensagemChatController.java
│           │   ├── dto/          ← Request e Response DTOs
│           │   ├── model/        ← Entidades JPA
│           │   ├── repository/   ← Spring Data JPA
│           │   └── service/      ← Regras de negócio
│           └── resources/
│               └── application.properties
└── frontend/
    └── index.html    ← Aplicação web completa (single-file)
```

---

## Pré-requisitos

| Ferramenta | Versão mínima |
|------------|---------------|
| Java (JDK) | 17            |
| Maven      | 3.8+          |
| MySQL      | 8.0+          |

---

## Passo a passo para rodar

### 1. Criar o banco de dados

Execute o script SQL no seu MySQL:

```sql
-- Cole o conteúdo do arquivo Banco_de_dados.sql no MySQL Workbench
-- ou via terminal:
mysql -u root -p < Banco_de_dados.sql
```

O script cria automaticamente o banco `sistema_automotivo` e todas as tabelas.

---

### 2. Configurar a conexão

Edite o arquivo:
```
backend/src/main/resources/application.properties
```

Altere as linhas abaixo com suas credenciais MySQL:

```properties
spring.datasource.url=jdbc:mysql://localhost:3306/sistema_automotivo?useSSL=false&serverTimezone=America/Sao_Paulo&allowPublicKeyRetrieval=true
spring.datasource.username=root
spring.datasource.password=SUA_SENHA_AQUI
```

---

### 3. Iniciar o backend

Abra um terminal na pasta `backend/` e execute:

```bash
# Com Maven instalado no sistema:
mvn spring-boot:run

# Ou usando o wrapper (se disponível):
./mvnw spring-boot:run
```

A API estará disponível em: **http://localhost:8080**

Aguarde a mensagem:
```
Started AutomotivoApplication in X.XXX seconds
```

---

### 4. Abrir o frontend

Simplesmente abra o arquivo no seu navegador:

```
frontend/index.html
```

Clique duas vezes no arquivo **index.html** — ele funciona diretamente sem servidor web extra.

> O frontend já aponta para `http://localhost:8080/api` por padrão.

---

## Endpoints da API

| Método | Rota | Descrição |
|--------|------|-----------|
| GET | /api/usuarios | Listar todos os usuários |
| POST | /api/usuarios | Criar usuário |
| GET | /api/usuarios/{id} | Buscar por ID |
| PUT | /api/usuarios/{id} | Atualizar usuário |
| DELETE | /api/usuarios/{id} | Excluir usuário |
| GET | /api/clientes | Listar clientes |
| POST | /api/clientes | Criar cliente |
| GET | /api/oficinas | Listar oficinas |
| POST | /api/oficinas | Criar oficina |
| GET | /api/ordens | Listar OS (filtro: ?status=ABERTA) |
| POST | /api/ordens | Criar OS |
| PATCH | /api/ordens/{id}/status?status=X | Atualizar status da OS |
| PATCH | /api/ordens/{id}/responsavel?responsavelId=X | Atribuir responsável |
| GET | /api/chat/ordem/{ordemId} | Mensagens de uma OS |
| POST | /api/chat | Enviar mensagem |

### Status de OS disponíveis
- `ABERTA`
- `EM_ANDAMENTO`
- `AGUARDANDO_PECA`
- `FECHADA`

### Perfis de usuário disponíveis
- `CLIENTE`
- `N1` — Atendimento
- `N2` — Técnico
- `N3` — Especialista

---

## Exemplo de uso rápido (via cURL)

```bash
# 1. Criar um usuário atendente N1
curl -X POST http://localhost:8080/api/usuarios \
  -H "Content-Type: application/json" \
  -d '{"nome":"João Silva","email":"joao@auto.com","senha":"123456","perfil":"N1"}'

# 2. Criar um cliente
curl -X POST http://localhost:8080/api/clientes \
  -H "Content-Type: application/json" \
  -d '{"documento":"123.456.789-00","razaoSocial":"Ana Paula","telefone":"(71) 99999-0000","usuarioId":1}'

# 3. Criar uma OS
curl -X POST http://localhost:8080/api/ordens \
  -H "Content-Type: application/json" \
  -d '{"clienteId":1,"modeloVeiculo":"Civic 2020","descricaoProblema":"Motor falhando ao acelerar"}'

# 4. Enviar mensagem no chat
curl -X POST http://localhost:8080/api/chat \
  -H "Content-Type: application/json" \
  -d '{"ordemServicoId":1,"remetenteId":1,"mensagem":"Olá! Seu veículo foi recebido."}'
```

---

## Dicas de problemas comuns

**Erro de conexão com banco:**
- Verifique se o MySQL está rodando
- Confirme usuário e senha em `application.properties`
- Certifique-se de que executou o script SQL

**Erro CORS no frontend:**
- Confirme que o backend está em `http://localhost:8080`
- Não acesse o `index.html` por um servidor diferente sem ajustar a config de CORS

**Porta 8080 ocupada:**
- Altere em `application.properties`: `server.port=8081`
- Atualize a variável `API` no topo do `index.html` para a nova porta

---

## Tecnologias utilizadas

- **Backend:** Java 17 · Spring Boot 3.2 · Spring Data JPA · Spring Validation · MySQL Connector
- **Frontend:** HTML5 · CSS3 · JavaScript puro (Fetch API) — sem frameworks, sem dependências externas
- **Banco:** MySQL 8 com o schema fornecido (`sistema_automotivo`)
