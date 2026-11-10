/*********** Defini‡äes  ************/
DEF VAR iContRot      AS INT INIT 0 NO-UNDO.
DEF VAR iContOper     AS INT INIT 0 NO-UNDO.
DEF VAR iContOperFerr AS INT INIT 0 NO-UNDO.
DEF VAR iContErro     AS INT INIT 0 NO-UNDO.

{cdp/cdcfgman.i}
{cdg/cdg0666.i}   /* tt-erro */
{utp/ut-glob.i}  

/*** rot-fabric -> rot-fab-dbr ***/
DEFINE TEMP-TABLE tt-rot-fab-dbr NO-UNDO
    FIELD cod-roteiro    AS    CHARACTER
    field descricao      AS    CHARACTER
    field cod-respons    AS    CHARACTER
    field idi-sit-rotei  AS    INTEGER
    INDEX codigo IS PRIMARY UNIQUE
          cod-roteiro.

/*** operacao -> operac-engr ***/
DEFINE TEMP-TABLE tt-operac-engr    NO-UNDO
      FIELD it-codigo          AS       CHARACTER       
      FIELD cod-roteiro        AS       CHARACTER       
      FIELD op-codigo          AS       INTEGER  
      FIELD descricao          AS       CHARACTER
      FIELD tipo-oper          AS       INTEGER
      FIELD gm-codigo          AS       CHARACTER       
      FIELD nr-unidades        AS       INTEGER
      FIELD tempo-prepar       AS       DECIMAL      
      FIELD tempo-homem        AS       DECIMAL 
      FIELD tempo-maquin       AS       DECIMAL
      FIELD data-inicio        AS       DATE        
      FIELD data-termino       AS       DATE        
      FIELD nr-oper-pad        AS       INTEGER
      FIELD num-id-operacao    AS       INTEGER
      FIELD tempo-sig          AS       LOGICAL
      FIELD cod-reduc-prepar   AS       CHARACTER
      INDEX id IS PRIMARY UNIQUE
            num-id-operacao.

/**** utilizada para exportar as operacoes do roteiro de fabrica‡Æo ***/
DEFINE TEMP-TABLE tt-operac-rot NO-UNDO LIKE tt-operac-engr
       INDEX operac-rot IS PRIMARY
             cod-roteiro.

/*** op-ferram -> op-ferr-dbr ***/
DEFINE TEMP-TABLE tt-op-ferr-dbr NO-UNDO
      FIELD ferramenta         AS  CHARACTER
      FIELD op-altern          AS  INTEGER
      FIELD num-id-operacao    AS  INTEGER
      FIELD sequencia          AS  INTEGER
      INDEX id IS PRIMARY UNIQUE
            num-id-operacao
            op-altern
            ferramenta
      INDEX ferr
            ferramenta.

/*** ctrab-operac-aloc -> ctrab-op-dbr ***/
DEFINE NEW SHARED TEMP-TABLE tt-ctrab-op-dbr NO-UNDO
    FIELD num-id-operacao   AS INTEGER
    FIELD op-altern         AS INTEGER
    FIELD cod-ctrab         AS CHARACTER
    FIELD prioridade        AS INTEGER
    FIELD val-perform       AS DECIMAL
    INDEX prior IS PRIMARY UNIQUE
          num-id-operacao op-altern prioridade.
