create database Camera;

-- Tabela de Câmera
create table Camera (
    id int auto_increment primary key,
    nome varchar(100) not null,
    localizacao varchar(100) not null,
    status enum('ATIVA', 'INATIVA') not null default 'ATIVA',
    enderecoMAC varchar(17) unique no null
);

-- Tabela de Capturas de Imagem
create table Captura (
    id int auto_increment primary key,
    camera_id int not null,
    timestamp timestmap default current_timestamp,
    urlImagem varchar(255),
    statusProcesso enum('PENDENTE', 'PROCESSADO', 'ERRO') default 'PENDENTE',
    foreign key (camera_id) references Camera(id) on delete cascade
);

-- Tabela de Processamento de Imagem (ProcessamentoIA)
create table ProcessamentoIA (
    id int auto_increment primary key,
    captura_id int not null,
    resultadoAnalise text,
    dataAnalise timestmap default current_timestamp,
    foreign key (captura_id) references Captura(id) on delete cascade
);

-- Tabela de Log de Auditoria e Feedback Auditivo
create table LogAuditoria (
    id int auto_increment primary key,
    camera_id int,
    tipoEvento enum('CONEXAO_ESTABELECIDA', 'ERRO_CONEXAO', 'IMAGEM_CAPTURADA', 'PROCESSAMENTO_CONCLUIDO', 'ERRO_PROCESSAMENTO', 'RESULTADO_DISPONIVEL') NOT NULL,
    mensagem varchar(255),
    timestamp timestmap default current_timestamp,
    foreign key (camera_id) references Camera(id) on delete cascade
);

-- Inserindo uma câmera
insert into Camera (nome, localizacao, enderecoMAC) 
values ('Camera 1', 'Entrada Principal', '00:1A:7D:DA:71:13');

-- Registrando uma captura de imagem
insert into Captura (camera_id, urlImagem, statusProcesso) 
values (1, 'https://exemplo.com/imagem1.jpg', 'PENDENTE');

-- Inserindo um log de conexão estabelecida
insert into LogAuditoria (camera_id, tipoEvento, mensagem) 
values (1, 'CONEXAO_ESTABELECIDA', 'Conexão Bluetooth estabelecida com sucesso.');

-- Consultar capturas e resultados de processamento para uma câmera específica
select c.id as captura_id, c.timestamp, c.urlImagem, p.resultadoAnalise, l.tipoEvento, l.mensagem
from Captura as c
join ProcessamentoIA as p on c.id = p.captura_id
join LogAuditoria as l on c.camera_id = l.camera_id
where c.camera_id = 1;
