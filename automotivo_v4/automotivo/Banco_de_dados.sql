CREATE DATABASE IF NOT EXISTS sistema_automotivo;
USE sistema_automotivo;

-- Tabela de Usuários (Atendentes N1, N2, N3 e Clientes)
CREATE TABLE IF NOT EXISTS usuarios (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    senha VARCHAR(255) NOT NULL,
    perfil ENUM('CLIENTE', 'N1', 'N2', 'N3') NOT NULL,
    data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabela de Clientes/Empresas
CREATE TABLE IF NOT EXISTS clientes (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    usuario_id BIGINT,
    razao_social VARCHAR(150),
    documento VARCHAR(20) UNIQUE NOT NULL,
    telefone VARCHAR(20),
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id)
);

-- Tabela de Oficinas Parceiras (sem latitude/longitude)
CREATE TABLE IF NOT EXISTS oficinas_parceiras (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    endereco VARCHAR(255) NOT NULL
);

-- Tabela de Ordens de Serviço (OS)
CREATE TABLE IF NOT EXISTS ordens_servico (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    cliente_id BIGINT NOT NULL,
    modelo_veiculo VARCHAR(100) NOT NULL,
    descricao_problema TEXT NOT NULL,
    status ENUM('ABERTA', 'EM_ANDAMENTO', 'AGUARDANDO_PECA', 'FECHADA') DEFAULT 'ABERTA',
    responsavel_id BIGINT,
    data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    data_fechamento TIMESTAMP NULL,
    FOREIGN KEY (cliente_id) REFERENCES clientes(id),
    FOREIGN KEY (responsavel_id) REFERENCES usuarios(id)
);

-- Tabela de Chat (Histórico)
CREATE TABLE IF NOT EXISTS mensagens_chat (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    ordem_servico_id BIGINT NOT NULL,
    remetente_id BIGINT NOT NULL,
    mensagem TEXT NOT NULL,
    data_envio TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (ordem_servico_id) REFERENCES ordens_servico(id) ON DELETE CASCADE,
    FOREIGN KEY (remetente_id) REFERENCES usuarios(id)
);

-- ============================================================
-- AGENDAMENTOS
-- ============================================================
CREATE TABLE IF NOT EXISTS agendamentos (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    cliente_id BIGINT NOT NULL,
    oficina_id BIGINT NOT NULL,
    data_hora DATETIME NOT NULL,
    tipo_servico VARCHAR(100) NOT NULL,
    status ENUM('PENDENTE','CONFIRMADO','REAGENDADO','CANCELADO') DEFAULT 'PENDENTE',
    cancelado_por_id BIGINT NULL,
    motivo_cancelamento TEXT NULL,
    data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (cliente_id)      REFERENCES clientes(id),
    FOREIGN KEY (oficina_id)      REFERENCES oficinas_parceiras(id),
    FOREIGN KEY (cancelado_por_id) REFERENCES usuarios(id)
);

-- Histórico de reagendamentos
CREATE TABLE IF NOT EXISTS historico_agendamento (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    agendamento_id BIGINT NOT NULL,
    data_hora_anterior DATETIME NOT NULL,
    data_hora_nova      DATETIME NOT NULL,
    alterado_por_id    BIGINT NOT NULL,
    observacao         TEXT NULL,
    data_alteracao     TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (agendamento_id)  REFERENCES agendamentos(id) ON DELETE CASCADE,
    FOREIGN KEY (alterado_por_id) REFERENCES usuarios(id)
);
