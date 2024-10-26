-- -----------------------------------------------------
-- Schema wings
-- -----------------------------------------------------

CREATE SCHEMA IF NOT EXISTS `wings` DEFAULT CHARACTER SET utf8;
USE `wings`;

-- Cria a tabela 'pessoas', que armazena informações básicas sobre indivíduos.
-- Cada pessoa é identificada de forma única pelo CPF
CREATE TABLE IF NOT EXISTS `pessoas` (
  `cpf` CHAR(14) NOT NULL,
  `nome` VARCHAR(90) NOT NULL,
  `telefone` VARCHAR(14) NOT NULL,
  PRIMARY KEY (`cpf`)
) ENGINE = InnoDB;

-- Cria a tabela 'cliente', que representa os clientes do sistema.
-- Cada cliente é associado a uma pessoa na tabela 'pessoas'.
CREATE TABLE IF NOT EXISTS `cliente` (
  `idcliente` INT NOT NULL AUTO_INCREMENT,
  `data_nasc` DATE NOT NULL,
  `menor_de_idade` TINYINT NOT NULL,
  `pessoas_cpf` CHAR(14) NOT NULL,
  PRIMARY KEY (`idcliente`, `pessoas_cpf`),
  INDEX `fk_cliente_pessoas_idx` (`pessoas_cpf`),
  CONSTRAINT `fk_cliente_pessoas`
    FOREIGN KEY (`pessoas_cpf`)
    REFERENCES `pessoas` (`cpf`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
) ENGINE = InnoDB;

-- Cria a tabela 'funcionario', que representa os funcionários do sistema.
-- Cada funcionário também é associado a uma pessoa na tabela 'pessoas'.
CREATE TABLE IF NOT EXISTS `funcionario` (
  `idfuncionario` INT NOT NULL AUTO_INCREMENT,
  `funcao` VARCHAR(45) NOT NULL,
  `salario` FLOAT NOT NULL,
  `pessoas_cpf` CHAR(14) NOT NULL,
  PRIMARY KEY (`idfuncionario`, `pessoas_cpf`),
  INDEX `fk_funcionario_pessoas1_idx` (`pessoas_cpf`),
  CONSTRAINT `fk_funcionario_pessoas1`
    FOREIGN KEY (`pessoas_cpf`)
    REFERENCES `pessoas` (`cpf`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
) ENGINE = InnoDB;

-- Cria a tabela 'reserva', que representa reservas feitas por clientes.
-- Cada reserva é identificada de forma única por um ID.
CREATE TABLE IF NOT EXISTS `reserva` (
  `idreserva` INT NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`idreserva`)
) ENGINE = InnoDB;

-- Cria a tabela 'cobranca', que representa cobranças associadas a reservas.
-- Cada cobrança é identificada por um ID.
CREATE TABLE IF NOT EXISTS `cobranca` (
  `idcobranca` INT NOT NULL AUTO_INCREMENT,
  `valor` FLOAT NOT NULL,
  PRIMARY KEY (`idcobranca`)
) ENGINE = InnoDB;

-- Cria a tabela 'gera', que relaciona reservas e cobranças.
-- Cada entrada nesta tabela conecta uma reserva a uma cobrança.
CREATE TABLE IF NOT EXISTS `gera` (
  `reserva_idreserva` INT NOT NULL,
  `cobranca_idcobranca` INT NOT NULL,
  INDEX `fk_gera_reserva1_idx` (`reserva_idreserva`),
  INDEX `fk_gera_cobranca1_idx` (`cobranca_idcobranca`),
  CONSTRAINT `fk_gera_reserva1`
    FOREIGN KEY (`reserva_idreserva`)
    REFERENCES `reserva` (`idreserva`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_gera_cobranca1`
    FOREIGN KEY (`cobranca_idcobranca`)
    REFERENCES `cobranca` (`idcobranca`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
) ENGINE = InnoDB;

-- Cria a tabela 'forma_de_pagamento', que armazena as opções de pagamento disponíveis.
-- Cada forma de pagamento é identificada por um ID.
CREATE TABLE IF NOT EXISTS `forma_de_pagamento` (
  `idforma_de_pagamento` INT NOT NULL AUTO_INCREMENT,
  `desconto` TINYINT NULL,
  `debito` TINYINT NULL,
  `credito` TINYINT NULL,
  `dinheiro` TINYINT NULL,
  `pix` TINYINT NULL,
  PRIMARY KEY (`idforma_de_pagamento`)
) ENGINE = InnoDB;

-- Cria a tabela 'check-in', que registra os horários de check-in dos passageiros.
-- Cada check-in é identificado de forma única por um ID.
CREATE TABLE IF NOT EXISTS `check-in` (
  `idcheck-in` INT NOT NULL AUTO_INCREMENT,
  `data_hora` DATETIME NOT NULL,
  PRIMARY KEY (`idcheck-in`)
) ENGINE = InnoDB;

-- Cria a tabela 'bagagem', que registra informações sobre a bagagem dos passageiros.
-- Cada bagagem é identificada de forma única por um ID.
CREATE TABLE IF NOT EXISTS `bagagem` (
  `idbagagem` INT NOT NULL AUTO_INCREMENT,
  `despacho` TINYINT NULL,
  `entregue` TINYINT NULL,
  `extraviada` TINYINT NULL,
  `transportando` TINYINT NULL,
  PRIMARY KEY (`idbagagem`)
) ENGINE = InnoDB;

-- Cria a tabela 'envia', que relaciona check-ins e bagagens.
-- Cada entrada nesta tabela conecta um check-in a uma bagagem.
CREATE TABLE IF NOT EXISTS `envia` (
  `check-in_idcheck-in` INT NOT NULL,
  `bagagem_idbagagem` INT NOT NULL,
  INDEX `fk_envia_check-in1_idx` (`check-in_idcheck-in`),
  INDEX `fk_envia_bagagem1_idx` (`bagagem_idbagagem`),
  CONSTRAINT `fk_envia_check-in1`
    FOREIGN KEY (`check-in_idcheck-in`)
    REFERENCES `check-in` (`idcheck-in`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_envia_bagagem1`
    FOREIGN KEY (`bagagem_idbagagem`)
    REFERENCES `bagagem` (`idbagagem`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
) ENGINE = InnoDB;

-- Cria a tabela 'fun_solo', que representa funcionários que atuam de forma isolada.
-- Cada entrada nesta tabela é identificada por um ID e associada a um funcionário.
CREATE TABLE IF NOT EXISTS `fun_solo` (
  `idfun_solo` INT NOT NULL AUTO_INCREMENT,
  `funcionario_idfuncionario` INT NOT NULL,
  `funcionario_pessoas_cpf` CHAR(14) NOT NULL,
  PRIMARY KEY (`idfun_solo`, `funcionario_idfuncionario`, `funcionario_pessoas_cpf`),
  INDEX `fk_fun_solo_funcionario1_idx` (`funcionario_idfuncionario`, `funcionario_pessoas_cpf`),
  CONSTRAINT `fk_fun_solo_funcionario1`
    FOREIGN KEY (`funcionario_idfuncionario`, `funcionario_pessoas_cpf`)
    REFERENCES `funcionario` (`idfuncionario`, `pessoas_cpf`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
) ENGINE = InnoDB;

-- Cria a tabela 'fun_tripulante', que representa funcionários que atuam como tripulantes.
-- Cada entrada nesta tabela é identificada por um ID e associada a um funcionário.
CREATE TABLE IF NOT EXISTS `fun_tripulante` (
  `idfun_tripulante` INT NOT NULL AUTO_INCREMENT,
  `funcionario_idfuncionario` INT NOT NULL,
  `funcionario_pessoas_cpf` CHAR(14) NOT NULL,
  PRIMARY KEY (`idfun_tripulante`, `funcionario_idfuncionario`, `funcionario_pessoas_cpf`),
  INDEX `fk_fun_tripulante_funcionario1_idx` (`funcionario_idfuncionario`, `funcionario_pessoas_cpf`),
  CONSTRAINT `fk_fun_tripulante_funcionario1`
    FOREIGN KEY (`funcionario_idfuncionario`, `funcionario_pessoas_cpf`)
    REFERENCES `funcionario` (`idfuncionario`, `pessoas_cpf`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
) ENGINE = InnoDB;

-- Cria a tabela 'guarda', que relaciona funcionários solo a bagagens que eles estão guardando.
CREATE TABLE IF NOT EXISTS `guarda` (
  `fun_solo_idfun_solo` INT NOT NULL,
  `fun_solo_funcionario_idfuncionario` INT NOT NULL,
  `fun_solo_funcionario_pessoas_cpf` CHAR(14) NOT NULL,
  `bagagem_idbagagem` INT NOT NULL,
  INDEX `fk_guarda_fun_solo1_idx` (`fun_solo_idfun_solo`, `fun_solo_funcionario_idfuncionario`, `fun_solo_funcionario_pessoas_cpf`),
  INDEX `fk_guarda_bagagem1_idx` (`bagagem_idbagagem`),
  CONSTRAINT `fk_guarda_fun_solo1`
    FOREIGN KEY (`fun_solo_idfun_solo`, `fun_solo_funcionario_idfuncionario`, `fun_solo_funcionario_pessoas_cpf`)
    REFERENCES `fun_solo` (`idfun_solo`, `funcionario_idfuncionario`, `funcionario_pessoas_cpf`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_guarda_bagagem1`
    FOREIGN KEY (`bagagem_idbagagem`)
    REFERENCES `bagagem` (`idbagagem`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
) ENGINE = InnoDB;

-- Cria a tabela 'voo', que armazena informações sobre voos.
-- Cada voo é identificado de forma única por um ID.
CREATE TABLE IF NOT EXISTS `voo` (
  `idvoo` INT NOT NULL AUTO_INCREMENT,
  `status_voo` VARCHAR(45) NOT NULL,
  `origem` VARCHAR(90) NOT NULL,
  `destino` VARCHAR(90) NOT NULL,
  `hora_chegada` DATETIME NOT NULL,
  `hora_saida` DATETIME NOT NULL,
  PRIMARY KEY (`idvoo`)
) ENGINE = InnoDB;

-- Cria a tabela 'armazena', que relaciona bagagens a voos.
-- Cada entrada nesta tabela conecta uma bagagem a um voo.
CREATE TABLE IF NOT EXISTS `armazena` (
  `bagagem_idbagagem` INT NOT NULL,
  `voo_idvoo` INT NOT NULL,
  INDEX `fk_armazena_bagagem1_idx` (`bagagem_idbagagem`),
  INDEX `fk_armazena_voo1_idx` (`voo_idvoo`),
  CONSTRAINT `fk_armazena_bagagem1`
    FOREIGN KEY (`bagagem_idbagagem`)
    REFERENCES `bagagem` (`idbagagem`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_armazena_voo1`
    FOREIGN KEY (`voo_idvoo`)
    REFERENCES `voo` (`idvoo`) 
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
) ENGINE = InnoDB;

-- Inserindo dados na tabela `pessoas`
INSERT INTO `pessoas` (cpf, nome, telefone) VALUES
('12345678901', 'João Silva', '1234-5678'),
('23456789012', 'Maria Oliveira', '2345-6789'),
('34567890123', 'Carlos Pereira', '3456-7890');

-- Inserindo dados na tabela `cliente`
INSERT INTO `cliente` (data_nasc, menor_de_idade, pessoas_cpf) VALUES
('2000-05-15', 0, '12345678901'),
('2010-07-20', 1, '23456789012');

-- Inserindo dados na tabela `funcionario`
INSERT INTO `funcionario` (funcao, salario, pessoas_cpf) VALUES
('Piloto', 15000.00, '12345678901'),
('Comissário', 5000.00, '34567890123');

-- Inserindo dados na tabela `reserva`
INSERT INTO `reserva` VALUES (1), (2);

-- Inserindo dados na tabela `cobranca`
INSERT INTO `cobranca` (valor) VALUES (200.00), (150.00);

-- Inserindo dados na tabela `forma_de_pagamento`
INSERT INTO `forma_de_pagamento` (desconto, debito, credito, dinheiro, pix) VALUES
(10, 1, 1, 0, 0);

-- Inserindo dados na tabela `check-in`
INSERT INTO `check-in` (data_hora) VALUES
('2024-10-25 10:00:00'),
('2024-10-25 10:30:00');

-- Inserindo dados na tabela `bagagem`
INSERT INTO `bagagem` (despacho, entregue, extraviada, transportando) VALUES
(1, 0, 0, 1),
(0, 1, 0, 0);

-- Inserindo dados na tabela `voo`
INSERT INTO `voo` (status_voo, origem, destino, hora_chegada, hora_saida) VALUES
('Programado', 'São Paulo', 'Rio de Janeiro', '2024-10-25 12:00:00', '2024-10-25 10:00:00');

-- Consultar dados da tabela `pessoas`
SELECT * FROM `pessoas`;

-- Consultar dados da tabela `cliente`
SELECT * FROM `cliente`;

-- Consultar dados da tabela `funcionario`
SELECT * FROM `funcionario`;

-- Consultar dados da tabela `reserva`
SELECT * FROM `reserva`;

-- Consultar dados da tabela `cobranca`
SELECT * FROM `cobranca`;

-- Consultar dados da tabela `forma_de_pagamento`
SELECT * FROM `forma_de_pagamento`;

-- Consultar dados da tabela `check-in`
SELECT * FROM `check-in`;

-- Consultar dados da tabela `bagagem`
SELECT * FROM `bagagem`;

-- Consultar dados da tabela `voo`
SELECT * FROM `voo`;

