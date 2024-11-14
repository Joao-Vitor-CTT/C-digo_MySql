CREATE DATABASE Camera;

-- Tabela de Câmera
CREATE TABLE Camera (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    localizacao VARCHAR(100) NOT NULL,
    status ENUM('ATIVA', 'INATIVA') NOT NULL DEFAULT 'ATIVA',
    enderecoMAC VARCHAR(17) UNIQUE NOT NULL
);

-- Tabela de Capturas de Imagem
CREATE TABLE Captura (
    id INT AUTO_INCREMENT PRIMARY KEY,
    camera_id INT NOT NULL,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    urlImagem VARCHAR(255),
    statusProcesso ENUM('PENDENTE', 'PROCESSADO', 'ERRO') DEFAULT 'PENDENTE',
    FOREIGN KEY (camera_id) REFERENCES Camera(id) ON DELETE CASCADE
);

-- Tabela de Processamento de Imagem (ProcessamentoIA)
CREATE TABLE ProcessamentoIA (
    id INT AUTO_INCREMENT PRIMARY KEY,
    captura_id INT NOT NULL,
    resultadoAnalise TEXT,
    dataAnalise TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (captura_id) REFERENCES Captura(id) ON DELETE CASCADE
);

-- Tabela de Log de Auditoria e Feedback Auditivo
CREATE TABLE LogAuditoria (
    id INT AUTO_INCREMENT PRIMARY KEY,
    camera_id INT,
    tipoEvento ENUM('CONEXAO_ESTABELECIDA', 'ERRO_CONEXAO', 'IMAGEM_CAPTURADA', 'PROCESSAMENTO_CONCLUIDO', 'ERRO_PROCESSAMENTO', 'RESULTADO_DISPONIVEL') NOT NULL,
    mensagem VARCHAR(255),
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (camera_id) REFERENCES Camera(id) ON DELETE SET NULL
);

-- Inserindo uma câmera
INSERT INTO Camera (nome, localizacao, enderecoMAC) 
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
