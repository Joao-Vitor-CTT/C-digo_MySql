create database Camera;

-- Tabela de Câmera
create table Camera (
    id INT AUTO_INCREMENT primary key,
    nome VARCHAR(100) not null,
    localizacao VARCHAR(100) not null,
    status ENUM('ATIVA', 'INATIVA') not null default 'ATIVA',
    enderecoMAC VARCHAR(17) unique no null
);

-- Tabela de Capturas de Imagem
create table Captura (
    id INT AUTO_INCREMENT primary key,
    camera_id INT not null,
    timestamp TIMESTAMP default current_timestamp,
    urlImagem VARCHAR(255),
    statusProcesso ENUM('PENDENTE', 'PROCESSADO', 'ERRO') default 'PENDENTE',
    foreign key (camera_id) references Camera(id) on delete cascade
);

-- Tabela de Processamento de Imagem (ProcessamentoIA)
create table ProcessamentoIA (
    id INT AUTO_INCREMENT primary key,
    captura_id INT not null,
    resultadoAnalise TEXT,
    dataAnalise TIMESTAMP default current_timestamp,
    foreign key (captura_id) references Captura(id) on delete cascade
);

-- Tabela de Log de Auditoria e Feedback Auditivo
create table LogAuditoria (
    id INT AUTO_INCREMENT primary key,
    camera_id INT,
    tipoEvento ENUM('CONEXAO_ESTABELECIDA', 'ERRO_CONEXAO', 'IMAGEM_CAPTURADA', 'PROCESSAMENTO_CONCLUIDO', 'ERRO_PROCESSAMENTO', 'RESULTADO_DISPONIVEL') NOT NULL,
    mensagem VARCHAR(255),
    timestamp TIMESTAMP default current_timestamp,
    foreign key (camera_id) references Camera(id) on delete cascade
);

-- Inserindo uma câmera
insert into Camera (nome, localizacao, enderecoMAC) 
VALUES ('Camera 1', 'Entrada Principal', '00:1A:7D:DA:71:13');

-- Registrando uma captura de imagem
INSERT INTO Captura (camera_id, urlImagem, statusProcesso) 
VALUES (1, 'https://exemplo.com/imagem1.jpg', 'PENDENTE');

-- Inserindo um log de conexão estabelecida
INSERT INTO LogAuditoria (camera_id, tipoEvento, mensagem) 
VALUES (1, 'CONEXAO_ESTABELECIDA', 'Conexão Bluetooth estabelecida com sucesso.');

-- Consultar capturas e resultados de processamento para uma câmera específica
SELECT c.id AS captura_id, c.timestamp, c.urlImagem, p.resultadoAnalise, l.tipoEvento, l.mensagem
FROM Captura AS c
JOIN ProcessamentoIA AS p ON c.id = p.captura_id
JOIN LogAuditoria AS l ON c.camera_id = l.camera_id
WHERE c.camera_id = 1;
