/********************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/


/** Sele‡Æo **/
define temp-table ttSelecao no-undo
     field empresa-ini    like mpn-pneu.ep-codigo-atual
     field empresa-fim    like mpn-pneu.ep-codigo-atual
     field equipto-ini    like mpn-pneu.cod-eqpto-atual 
     field equipto-fim    like mpn-pneu.cod-eqpto-atual
     field pneu-ini       like mpn-pneu.cod-pneu
     field pneu-fim       like mpn-pneu.cod-pneu
     field modelo-ini     like mpn-pneu.cod-model-pneu
     field modelo-fim     like mpn-pneu.cod-model-pneu
     field estab-ini      like mpn-pneu.cod-estabel-atual
     field estab-fim      like mpn-pneu.cod-estabel-atual
     field marca-ini      like mpn-model.cod-marca
     field marca-fim      like mpn-model.cod-marca
     field medida-ini     like mpn-pneu.cod-medid
     field medida-fim     like mpn-pneu.cod-medid
     field vida-ini       like mpn-pneu.num-vida-atual
     field vida-fim       like mpn-pneu.num-vida-atual
     field situacao-ini   like mpn-pneu.cod-sit-pneu-atual
     field situacao-fim   like mpn-pneu.cod-sit-pneu-atual
     field controle-ini   like mpn-pneu.dat-inicial 
     field controle-fim   like mpn-pneu.dat-inicial
     field periodo-ini    like mpn-pneu.dat-situacao
     field periodo-fim    like mpn-pneu.dat-situacao
     field causa-ini      like mpn-pneu.cd-causa-padr
     field causa-fim      like mpn-pneu.cd-causa-padr
     field emitente-ini   like mpn-histor-vida.cod-emitente
     field emitente-fim   like mpn-histor-vida.cod-emitente
     FIELD placa-ini      LIKE mab-eqpto.cod-placa
     FIELD placa-fim      LIKE mab-eqpto.cod-placa
     field sulco-ini      AS DEC FORMAT ">>9.9" 
     field sulco-fim      AS DEC FORMAT ">>9.9" 
     field lAtivos        as logical  INITIAL YES   
     field lInativos      as LOGICAL  INITIAL NO   
     field lEqptoMot      as LOGICAL  INITIAL YES   
     field lEqptoNMot     as LOGICAL  INITIAL YES   
     field lEstoque       as logical  INITIAL YES   
     field lRadial        as logical  INITIAL YES   
     FIELD lDiagonal      as LOGICAL  INITIAL YES
    &IF DEFINED(bf_mnt_ems206b) &THEN
     FIELD unid-negoc-ini AS CHARACTER FORMAT "x(3)"
     FIELD unid-negoc-fim AS CHARACTER FORMAT "x(3)"
    &ENDIF
     FIELD tipo-mater-ini LIKE mab-histor-combust.cod-tip-mater
     FIELD tipo-mater-fim LIKE mab-histor-combust.cod-tip-mater.
     .


/**Temp-table para dados do Excell**/
define temp-table tt-dados-ex no-undo
    field arquivo-num                   as integer format ">9"     initial 1
    field planilha-num                  as integer format ">9"
    field celula-coluna                 as integer format ">>>>9"
    field celula-linha                  as integer format ">>>>9"
    field celula-cor-interior           as integer format ">9"     initial 58 /* None */
    field celula-formato                as char    format "x(255)"
    field celula-formula                as char    format "x(255)"
    field celula-alinhamento-horizontal as integer format "9"      initial 4 /* Left */
    field celula-alinhamento-vertical   as integer format "9"      initial 1 /* Bottom */
    field celula-valor                  as char    format "x(255)"
    field celula-fonte-nome             as char    format "x(255)" initial "Times New Roman"
    field celula-fonte-tamanho          as integer format ">9"     initial 10
    field celula-fonte-negrito          as logical                 initial no
    field celula-fonte-italico          as logical                 initial no
    field celula-fonte-sublinhado       as integer format "9"      initial 3 /* None */
    field celula-fonte-cor              as integer format ">9"     initial 57 /* Automatic */
    field celula-tipo-borda-sup         as integer format "9"      initial 7 /* None */
    field celula-tipo-borda-inf         as integer format "9"      initial 7 /* None */
    field celula-tipo-borda-esq         as integer format "9"      initial 7 /* None */
    field celula-tipo-borda-dir         as integer format "9"      initial 7 /* None */
    index tt-dados-pri is unique primary
        arquivo-num
        planilha-num
        celula-coluna
        celula-linha.


/*Defini‡Æo da TEMP-TABLES*/

def temp-table ttVisao no-undo
    field dimensao  as char
    field sequencia as integer
    index codigo is primary unique sequencia.

def temp-table ttVisao1 no-undo
    FIELD sequencia         AS INTEGER
    FIELD cod-dimensao      AS CHAR FORMAT "x(300)"
    FIELD cod-oficial       AS CHAR FORMAT "X(20)"
    FIELD desc-dimensao     AS CHAR FORMAT "x(30)"
    FIELD cod-dimens-pai    AS CHAR FORMAT "x(300)"
    FIELD quant-eqpto       AS INT  
    FIELD ano-vida          AS DEC FORMAT ">>>,>>9.99"
    FIELD Km-rodado         AS DEC FORMAT ">>>,>>>,>>>,>>9.9" 
    FIELD iIdMedia          AS DEC FORMAT ">>>9.99"
    field r-rowid           AS ROWID
    FIELD p-image           AS INT
    FIELD seq-tree          AS INT
    FIELD un                LIKE mab-model.un
    FIELD un-sec            AS CHAR FORMAT "x(03)"
    FIELD km-sec            AS DEC FORMAT ">>,>>>,>>9.9"
    FIELD hodometro-pri     AS DEC FORMAT ">>>,>>>,>>>,>>9.9" 
    FIELD hodometro-sec     AS DEC FORMAT ">>>,>>>,>>>,>>9.9" 
    index id is primary unique sequencia ASCENDING
                               cod-dimensao ASCENDING.
/******* USADO PARA O AB0609 ******/

/** Sele‡Æo **/
define temp-table ttSelecao2 no-undo
     field empresa-ini      like mab-eqpto.ep-codigo
     field empresa-fim      like mab-eqpto.ep-codigo
     field equipto-ini      like mab-eqpto.cod-eqpto
     field equipto-fim      like mab-eqpto.cod-eqpto
     field grupo-ini        like mab-eqpto.cod-grp-eqpto
     field grupo-fim        like mab-eqpto.cod-grp-eqpto
     field modelo-ini       like mab-eqpto.cod-model
     field modelo-fim       like mab-eqpto.cod-model
     field estab-ini        like mab-eqpto.cod-estabel
     field estab-fim        like mab-eqpto.cod-estabel
     field tag-ini          like mab-eqpto.cd-tag
     field tag-fim          like mab-eqpto.cd-tag
     field estrut-ini       like mab-eqpto.cod-estrut-mec
     field estrut-fim       like mab-eqpto.cod-estrut-mec
     field cc-cod-eqpto-ini like mab-eqpto.cc-codigo
     field cc-cod-eqpto-fim like mab-eqpto.cc-codigo
     field sit-ini          like mab-eqpto.cod-sit-eqpto
     field sit-fim          like mab-eqpto.cod-sit-eqpto
     field atividade-ini    like mab-histor-ativid.cod-ativid  
     field atividade-fim    like mab-histor-ativid.cod-ativid
     field periodo-ini      as date format "99/99/9999"
     field periodo-fim      as date format "99/99/9999"
     field trajeto-ini      like mab-abastec-lubrific.cod-rota
     field trajeto-fim      like mab-abastec-lubrific.cod-rota
     FIELD cc-cod-docto-ini like mab-eqpto.cc-codigo
     FIELD cc-cod-docto-fim like mab-eqpto.cc-codigo
     field lAtivos          as logical     
     field lProprios        as logical
     field lInativos        as logical
     field lTerceiros       as logical
     field lOK              as logical
     field lIrregular       as logical
     field lLogContSec      as logical
     field lDesperdicio     as logical
     field classificacao    as integer format "9"
     field cod-emitente-ini like mab-eqpto.cod-emitente
     field cod-emitente-fim like mab-eqpto.cod-emitente
    &IF DEFINED(bf_mnt_ems206b) &THEN
     FIELD cod-unid-negoc-ini AS CHARACTER FORMAT "x(3)"
     FIELD cod-unid-negoc-fim AS CHARACTER FORMAT "x(3)"
    &ENDIF
    .

define buffer bfttVisao1 for ttVisao1.
define buffer bfttVisao2 for ttVisao1.

