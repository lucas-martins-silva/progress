/*****************************************************************************
** Copyright DATASUL S.A. (2003)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*****************************************************************************/
/*----------------------------------------------------------------------------
    File        : axsar002.i
    Purpose     : Defini‡Æo das temp-tables utilizadas no envio do pre‡o
                  m‚dio dos itens
                  Utilizado nos programas CE0424   - Integra‡Æo Pre‡o Itens
                                          AXSAR002 - Envio Pre‡o M‚dio do Item
    CREATEd     : 09/03/2004 10:30
----------------------------------------------------------------------------*/

DEFINE TEMP-TABLE tt-item NO-UNDO
    FIELD it-codigo	    LIKE item.it-codigo
    FIELD desc-item	    LIKE item.desc-item
    FIELD data-base	    LIKE item.data-base    INITIAL today
    FIELD preco-base	LIKE item.preco-base
    FIELD dt-pr-fisc	LIKE item.dt-pr-fisc   INITIAL today
    FIELD preco-fiscal	LIKE item.preco-fiscal
    FIELD data-ult-rep	LIKE item.data-ult-rep INITIAL today
    FIELD preco-repos	LIKE item.preco-repos
    FIELD data-ult-ent	LIKE item.data-ult-ent INITIAL today
    FIELD preco-ul-ent	LIKE item.preco-ul-ent
    FIELD mo-codigo	    AS INTEGER   EXTENT 3
    FIELD mo-desc	    AS CHARACTER EXTENT 3
    FIELD mo-sigla	    AS CHARACTER EXTENT 3
    FIELD tem-moeda1	LIKE param-estoq.tem-moeda1
    FIELD tem-moeda2	LIKE param-estoq.tem-moeda2
    INDEX ch-item IS PRIMARY UNIQUE it-codigo.


DEFINE TEMP-TABLE tt-item-estab NO-UNDO
    FIELD it-codigo	     LIKE item.it-codigo
    FIELD cod-estabel	 LIKE item-uni-estab.cod-estabel
    FIELD desc-estabel	 LIKE estabelec.nome
    FIELD data-base	     LIKE item-uni-estab.data-base
    FIELD preco-base	 LIKE item-uni-estab.preco-base
    FIELD dt-pr-fisc	 LIKE item-uni-estab.dt-pr-fisc
    FIELD preco-fiscal	 LIKE item-uni-estab.preco-fiscal
    FIELD data-ult-rep	 LIKE item-uni-estab.data-ult-rep
    FIELD preco-repos	 LIKE item-uni-estab.preco-repos
    FIELD data-ult-ent	 LIKE item-uni-estab.data-ult-ent
    FIELD preco-ul-ent	 LIKE item-uni-estab.preco-ul-ent
    FIELD custo-contab	 LIKE estabelec.custo-contab INITIAL 1
    FIELD usa-mensal	 AS LOGICAL INITIAL FALSE
    FIELD tipo-pr-med	 LIKE param-estoq.tipo-pr-med
    FIELD mensal-ate	 LIKE item-estab.mensal-ate INITIAL today
    FIELD val-unit-mat-m LIKE item-estab.val-unit-mat-m
    FIELD val-unit-mob-m LIKE item-estab.val-unit-mob-m
    FIELD val-unit-ggf-m LIKE item-estab.val-unit-ggf-m
    FIELD usa-on-line	 AS LOGICAL INITIAL FALSE
    FIELD metodo-custeio AS INTEGER INITIAL 1
    FIELD on-line-ate	 LIKE item-estab.on-line-ate INITIAL today
    FIELD val-unit-mat-o LIKE item-estab.val-unit-mat-o
    FIELD val-unit-mob-o LIKE item-estab.val-unit-mob-o
    FIELD val-unit-ggf-o LIKE item-estab.val-unit-ggf-o
    FIELD usa-padrao	 AS LOGICAL INITIAL FALSE
    FIELD padrao-ate	 LIKE item-estab.padrao-ate INITIAL today
    FIELD val-unit-mat-p LIKE item-estab.val-unit-mat-p
    FIELD val-unit-mob-p LIKE item-estab.val-unit-mob-p
    FIELD val-unit-ggf-p LIKE item-estab.val-unit-ggf-p
    INDEX ch-item-estab IS PRIMARY UNIQUE it-codigo cod-estabel.


DEFINE TEMP-TABLE tt-saldo-custo NO-UNDO
    FIELD it-codigo	    LIKE item.it-codigo
    FIELD cod-estabel	LIKE item-uni-estab.cod-estabel
    FIELD seq-custeio	AS INTEGER
    FIELD cod-refer	    AS CHAR
    FIELD desc-refer	AS CHAR
    FIELD lote	        AS CHAR
    FIELD qt-original	AS DECIMAL
    FIELD qt-saldo	    AS DECIMAL
    FIELD valor-ori-mat	AS DECIMAL EXTENT 3
    FIELD valor-ori-mob	AS DECIMAL EXTENT 3
    FIELD valor-ori-ggf	AS DECIMAL EXTENT 3
    FIELD saldo-mat	    AS DECIMAL EXTENT 3
    FIELD saldo-mob	    AS DECIMAL EXTENT 3
    FIELD saldo-ggf	    AS DECIMAL EXTENT 3
    INDEX ch-item-estab-cust IS PRIMARY UNIQUE it-codigo cod-estabel seq-custeio.

/*--- FIM axsar002.i ---*/
