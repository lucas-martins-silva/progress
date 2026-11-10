/*:T*******************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC9050 2.00.00.008 } /*** "010008" ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i BC9050 MBC}
&ENDIF

{include/i_dbvers.i}  /* versao das bases e bases instaladas */

/* Definicao global do nome da transacao ---                */
&global-define ProgramName BC9050
&global-define TempTable tt-conf-docum-est
{bcp/bc9050.i " "}
{utp/utapi009.i} /* login */
{utp/ut-glob.i}                
{method/dbotterr.i}
{bcp/bc9015.i3}  /* def variaveis padroes */
{bcp/bc9048.i1} /* definicao variaveis menu padrao */
DEFINE VARIABLE l-menu-padrao AS LOGICAL INITIAL YES NO-UNDO.

DEFINE TEMP-TABLE ttWork NO-UNDO
    FIELD cod-usuario      AS CHARACTER FORMAT 'x(25)':U           LABEL 'Usuario'         
    FIELD cod-coletor      AS CHARACTER FORMAT 'x(14)':U           LABEL 'Coletor'      INITIAL ""
    FIELD cod-equipamento  AS CHARACTER FORMAT 'x(14)':U           LABEL 'Equipamento'  INITIAL ""
    FIELD qtd-conf         AS DECIMAL   FORMAT '>>>>>,>>9.9999':U  LABEL 'Qtd'
    FIELD nro-docto        AS CHARACTER FORMAT 'x(16)':U           LABEL 'Nr NF'
    FIELD serie            AS CHARACTER FORMAT 'x(05)':U           LABEL 'S‚rie'
    FIELD cod-emitente     AS INTEGER   FORMAT '>>>>>>>>9':U       
    FIELD nat-operacao     AS CHARACTER FORMAT 'x(06)':U     
    FIELD cod-estabel      LIKE docum-est.cod-estabel     
    FIELD cod-local        LIKE wm-local.cod-local         
    FIELD cod-deposito     LIKE wm-local.cod-deposito      
    FIELD sequencia        LIKE item-doc-est.sequencia
    FIELD cod-item         LIKE item-doc-est.it-codigo 
    FIELD lote             LIKE item-doc-est.lote      
    FIELD cod-refer        LIKE item-doc-est.cod-refer
    FIELD dt-vali-lote     LIKE item-doc-est.dt-vali-lote
    FIELD lNovo-item       AS LOGICAL.

CREATE ttWork.

DEFINE TEMP-TABLE tt-fornec-docto NO-UNDO
    FIELD nro-docto        AS CHARACTER FORMAT "x(16)":U
    FIELD serie            AS CHARACTER FORMAT "X(05)":U
    FIELD cod-emitente     AS INTEGER   FORMAT ">>>>>>>>9":U
    FIELD nat-operacao     AS CHARACTER FORMAT "x(6)":U
    FIELD nome-abrev       AS CHARACTER FORMAT "x(12):U"
    FIELD data-transacao   AS DATE.

DEFINE TEMP-TABLE tt-emitente NO-UNDO
    FIELD cod-emitente LIKE emitente.cod-emitente
    FIELD nome-abrev   LIKE emitente.nome-abrev.
 
DEFINE TEMP-TABLE tt-notas NO-UNDO
    FIELD nro-docto         LIKE docum-est.nro-docto
    FIELD serie             LIKE docum-est.serie-docto
    FIELD cod-emitente      LIKE docum-est.cod-emitente
    FIELD nat-operacao      LIKE docum-est.nat-operacao
    FIELD dt-trans          LIKE docum-est.dt-trans
    FIELD nome-abrev        LIKE emitente.nome-abrev
    INDEX idx-docto AS PRIMARY nro-docto serie cod-emitente nat-operacao.

DEFINE TEMP-TABLE tt-item-nota NO-UNDO
    FIELD cod-estabel       LIKE docum-est.cod-estabel                         
    FIELD cod-local         LIKE wm-local.cod-local
    FIELD cod-deposito      LIKE wm-local.cod-deposito                      
    FIELD nro-docto         LIKE docum-est.nro-docto
    FIELD serie             LIKE docum-est.serie-docto
    FIELD cod-emitente      LIKE docum-est.cod-emitente
    FIELD nat-operacao      LIKE docum-est.nat-operacao
    FIELD sequencia         LIKE item-doc-est.sequencia
    FIELD cod-item          LIKE item-doc-est.it-codigo
    FIELD lote              LIKE item-doc-est.lote         FORMAT "x(18)"
    FIELD cod-refer         LIKE item-doc-est.cod-refer
    FIELD dt-vali-lote      LIKE item-doc-est.dt-vali-lote
    INDEX idx-seq AS PRIMARY sequencia.

DEFINE QUERY qry-notas     FOR tt-notas.
DEFINE QUERY qry-item-nota FOR tt-item-nota.

DEFINE BROWSE brw-notas QUERY qry-notas NO-LOCK
             DISPLAY 
              tt-notas.nro-docto   COLUMN-LABEL "Nro. Docto"
              tt-notas.nome-abrev  COLUMN-LABEL "Nome Abrev."
                    WITH NO-BOX  SIZE 20 BY 5 NO-SCROLLBAR-VERTICAL.

DEFINE BROWSE brw-item-nota QUERY qry-item-nota NO-LOCK
             DISPLAY 
              tt-item-nota.sequencia        COLUMN-LABEL "Seq."
              tt-item-nota.cod-item         COLUMN-LABEL "Item"
              tt-item-nota.lote             COLUMN-LABEL "Lote"
                    WITH NO-BOX SIZE 20 BY 5 NO-SCROLLBAR-VERTICAL.

/* ************************** Definitions ******************************** */
DEFINE VARIABLE vLogOk                 AS LOGICAL   INIT NO           NO-UNDO.
DEFINE VARIABLE vCodSenha              AS CHARACTER FORMAT 'x(18)':U  NO-UNDO.
DEFINE VARIABLE vNomeUsuario           AS CHARACTER                   NO-UNDO.
DEFINE VARIABLE vLogControlaLogin      AS LOGICAL  INITIAL NO         NO-UNDO.
DEFINE VARIABLE vLogUtilizaColetor     AS LOGICAL  INITIAL NO         NO-UNDO.
DEFINE VARIABLE vLogAprovaFatura       AS LOGICAL  INITIAL NO         NO-UNDO.
DEFINE VARIABLE iCodTipoEquip          AS INTEGER                     NO-UNDO.
DEFINE VARIABLE iCodTipoColetor        AS INTEGER                     NO-UNDO.
DEFINE VARIABLE vLogProcesso           AS LOGICAL  INITIAL NO         NO-UNDO.
DEFINE VARIABLE vLogAtivo              AS LOGICAL  INITIAL NO         NO-UNDO.
DEFINE VARIABLE i-conta-fornec         AS INTEGER                     NO-UNDO.
DEFINE VARIABLE p-cod-emitente         AS INTEGER                     NO-UNDO.
DEFINE VARIABLE p-nat-oper             AS CHARACTER                   NO-UNDO.
DEFINE VARIABLE p-dt-trans             AS DATE                        NO-UNDO.
DEFINE VARIABLE p-nome-abrev           AS CHARACTER                   NO-UNDO.
DEFINE VARIABLE p-retornou-esc         AS LOGICAL              NO-UNDO.
DEFINE VARIABLE p-Log-conf-ok          AS LOGICAL              NO-UNDO.
DEFINE VARIABLE p-Id-carga             LIKE wm-carga.id-carga  NO-UNDO.
DEFINE VARIABLE vLogAnswer             AS LOGICAL     INIT NO  NO-UNDO.
DEFINE VARIABLE vLogRetorno            AS LOGICAL              NO-UNDO.
DEFINE VARIABLE c-cod-local-wms        AS CHARACTER            NO-UNDO.
DEFINE VARIABLE vOpcao                 AS INTEGER FORMAT "9"   NO-UNDO.

DEFINE VARIABLE wgbosc047              AS HANDLE               NO-UNDO.
DEFINE VARIABLE wgbosc048              AS HANDLE               NO-UNDO.
DEFINE VARIABLE wgbosc079              AS HANDLE               NO-UNDO.
DEFINE VARIABLE wgbosc092              AS HANDLE               NO-UNDO.
DEFINE VARIABLE wgboin089wm            AS HANDLE               NO-UNDO.
DEFINE VARIABLE wgbosc075              AS HANDLE               NO-UNDO.
DEFINE VARIABLE wgbcapiwms             AS HANDLE               NO-UNDO. 

&global-define ActiveObject1 wgbosc079
&global-define ActiveObject2 wgbosc092
&global-define ActiveObject3 wgboin089wm
&global-define ActiveObject4 wgbosc075
&global-define ActiveObject5 wgbcapiwms

&global-define ErrorDisplaySeconds 3
&global-define FrameSize    20 By 8 

/***************************************** Frames Inicio ******************************************/
/* Definicao da Frame01 ---                                 */
&global-define Frame01Name   Frame01
&global-define Frame01Defs   'Conf. Recebimento   '                             At Row 01 Col 01          ~
                             '--------------------'                             At Row 02 Col 01          ~
                             'Usr:'                                             At Row 03 Col 01          ~
                              ttWork.cod-usuario                                At Row 03 Col 05 No-label FORMAT "x(25)"  VIEW-AS FILL-IN SIZE 15 BY 0.88 ~
                             'Sen:'                                             AT ROW 04 COL 01          ~
                             vCodSenha                                          AT ROW 04 COL 05 NO-LABEL FORMAT "x(18)"  VIEW-AS FILL-IN SIZE 15 BY 0.88 ~
                             'Col:'                                             At Row 05 Col 01          ~
                              ttWork.cod-coletor                                At Row 05 Col 05 No-label ~
                             'Equ:'                                             At Row 06 Col 01          ~
                              ttWork.cod-equipamento                            At Row 06 Col 05 NO-LABEL
&global-define Frame01Repeat NO

/* Definicao da Frame02 ---                             */
&global-define Frame02Name   Frame02
&global-define Frame02Defs   'Conf. Recebimento   '                             At Row 01 Col 01          ~
                             '--------------------'                             At Row 02 Col 01          ~
                             '1 - Lista Notas'                                  AT ROW 04 COL 01          ~
                             '2 - Digita‡Æo'                                    AT ROW 05 COL 01          ~
                             "Op‡Æo:"                                           AT ROW 06 COL 01          ~
                             vOpcao                                             AT ROW 06 COL 07 NO-LABEL
&global-define Frame02Repeat NO

/* Definicao da Frame03 ---                             */
&global-define Frame03Name   Frame03
&global-define Frame03Defs   'Conf. Recebimento   '                             At Row 01 Col 01          ~
                             '--------------------'                             At Row 02 Col 01          ~
                             brw-notas                                          AT ROW 03 COL 01          ~
&global-define Frame03Repeat NO

&global-define Frame04Name   Frame04
&global-define Frame04Defs   'Conf. Recebimento   '                             At Row 01 Col 01          ~
                             '--------------------'                             At Row 02 Col 01          ~
                             brw-item-nota                                      AT ROW 03 COL 01          ~
&global-define Frame04Repeat NO

&global-define Frame05Name   Frame05
&global-define Frame05Defs   'Conf. Recebimento   '                             At Row 01 Col 01          ~
                             '--------------------'                             At Row 02 Col 01          ~
                             'Nr.NF:'                                           AT ROW 03 COL 01          ~
                             ttWork.nro-docto                                   AT ROW 04 COL 01 NO-LABEL ~
                             'S‚rie:'                                           AT ROW 05 COL 01          ~
                             ttWork.serie                                       AT ROW 05 COL 07 NO-LABEL
&global-define Frame05Repeat NO

/* Definicao dos campos a serem recebidos ---               */
&global-define Update01Fields ttWork.cod-usuario WHEN ttWork.cod-usuario = '' ~
                              vCodSenha          WHEN ttWork.cod-usuario = '' ~
                              ttWork.cod-coletor ~
                              ttWork.cod-equipamento

&global-define Update02Fields vOpcao

&global-define Update03Fields brw-notas WHEN vOpcao = 1

&global-define Update04Fields brw-item-nota

/* Definicao das trigger de interacao com a tela ---        */ 
&global-define TriggerBeforeFrame01 Run InicializaCamposFrame01. IF vLogSai = YES THEN DO: LEAVE _frame01. END.
&global-define TriggerBeforeFrame02 Run InicializaCamposFrame02.
&global-define TriggerBeforeFrame03 Run InicializaCamposFrame03. IF vLogRetorno = YES THEN DO: LEAVE _frame03. END.
&global-define TriggerBeforeFrame04 Run InicializaCamposFrame04.

&global-define TriggerAfterFrame01  Run GravaCamposFrame01.
&global-define TriggerAfterFrame02  Run GravaCamposFrame02.
&global-define TriggerAfterFrame03  Run GravaCamposFrame03.
&global-define TriggerAfterFrame04  Run GravaCamposFrame04.


/* Definicao das trigger de usuario ---                     */ 
&global-define UserTriggers ~
                            ON ENTRY OF ttWork.cod-coletor IN FRAME {&Frame01Name} ~
                            DO:                                                    ~
                                IF v_cod-coletor_corren     <> '' AND              ~
                                   v_cod-equipamento_corren <> '' THEN DO:         ~
                                    IF l-menu-padrao = YES THEN DO:                ~
                                        ASSIGN l-menu-padrao = NO.                 ~
                                        APPLY "Enter":U TO ttWork.cod-equipamento IN FRAME {&Frame01Name}. ~
                                    END.                                           ~
                                    ELSE DO:                                       ~
                                        APPLY "ESC":U TO ttWork.cod-coletor IN FRAME {&Frame01Name}. ~
                                    END.                                           ~
                                    RETURN NO-APPLY.                                   ~
                                END.                                               ~
                            END.                                                   ~
                            ON 'ESC':U OF Frame Frame01 ~
                            DO:                         ~
                                ASSIGN vlogerro = YES      ~
                                       vLogSai  = YES      ~
                                       vLogFinaliza = YES  ~
                                       vLogCancela = YES.  ~
                                Return 'NOK':U.            ~
                            END. ~
                            ON 'enter':U OF ttWork.cod-coletor IN Frame Frame01             ~
                            DO:                                                             ~
                                APPLY 'entry':U TO ttWork.cod-equipamento IN FRAME Frame01. ~
                                RETURN NO-APPLY.                                            ~
                            END.                                                            ~
                            ON 'Return':U OF brw-notas In Frame {&Frame03Name}              ~
                            DO:                                                             ~
                                Apply 'Go' To This-procedure.                               ~
                            END.                                                            ~
                            ON 'ESC':U OF Frame Frame05                                     ~
                            DO:                                                             ~
                                ASSIGN vLogRetorno = YES.                                   ~
                            END.                                                            ~
                            ON 'Return':U OF brw-item-nota In Frame {&Frame04Name}          ~
                            DO:                                                             ~
                                Apply 'Go' To This-procedure.                               ~
                            END.                                                            ~


{bcp/bc9100.i} /* Gerador da interface caracter do coleta de dados */
{bcp/bc9101.i} /* Procedure de atualizacao da transacao            */

/*************************************************************************************************** 
** Esta procedure eï executada pelo pre-processador {&TriggerBeforeFrame01}.                      **
****************************************************************************************************/
PROCEDURE InicializaCamposFrame01:
    IF v_cod_usuar_corren <> '' THEN DO: 
       ASSIGN vCodSenha:BLANK IN FRAME {&Frame01Name}                 = NO.
       ASSIGN ttWork.cod-usuario:SCREEN-VALUE IN FRAME {&Frame01Name} = v_cod_usuar_corren
              ttWork.cod-usuario                                      = v_cod_usuar_corren
              vCodSenha                                               = '****************':U 
              vCodSenha:SCREEN-VALUE IN FRAME {&Frame01Name}          = '****************':U. 
       IF v_cod-coletor_corren     <> '' AND 
           v_cod-equipamento_corren <> '' THEN DO:
            ASSIGN ttWork.cod-coletor:SCREEN-VALUE IN FRAME {&Frame01Name}     = v_cod-coletor_corren
                   ttWork.cod-coletor     = v_cod-coletor_corren
                   ttWork.cod-equipamento:SCREEN-VALUE IN FRAME {&Frame01Name} = v_cod-equipamento_corren
                   ttWork.cod-equipamento = v_cod-equipamento_corren.
       END.
    END.
    ELSE DO:
       ASSIGN vCodSenha:BLANK IN FRAME {&Frame01Name}                 = YES.
       ASSIGN ttWork.cod-usuario:SCREEN-VALUE IN FRAME {&Frame01Name} = '' 
              ttWork.cod-usuario                                      = '' 
              vCodSenha                                               = ''  
              vCodSenha:SCREEN-VALUE IN FRAME {&Frame01Name}          = ''.
    END.
END PROCEDURE.

/*************************************************************************************************** 
** Esta procedure esta armazenando na temp-table {&Temp-Table} os valores recebidos por ttWork    **
** na tela Frame 01.                                                                              **
** Esta procedure eï executada pelo pre-processador {&TriggerAfterFrame01}.                       **
****************************************************************************************************/
PROCEDURE GravaCamposFrame01:
    /* Validacoes Frame 01 Inicio --- */
    ASSIGN vLogErro          = NO
           vLogControlaLogin = NO.

    IF v_cod_usuar_corren <> "" THEN
       ASSIGN ttWork.cod-usuario = v_cod_usuar_corren.
    ELSE
       ASSIGN INPUT FRAME {&Frame01Name} ttWork.cod-usuario.

    IF v2_cod_usuar_corren = '' THEN DO:
       FOR EACH tt-erros:
          DELETE tt-erros.
       END.

       login:
       DO ON ERROR  UNDO login, LEAVE login
       ON QUIT      UNDO login, LEAVE login
       ON STOP      UNDO login, LEAVE login
       ON ENDKEY    UNDO login, LEAVE login:
          RUN btb/btapi910za.p (INPUT  ttWork.cod-usuario:SCREEN-VALUE IN FRAME {&Frame01Name}, 
                                INPUT  vCodSenha,
                                OUTPUT TABLE tt-erros) NO-ERROR. 
       END. 
       IF CAN-FIND (FIRST tt-erros WHERE tt-erros.cod-erro = 4753) THEN DO:
          {bcp/bc9105.i "4753" "Usu rio nÆo encontrado. (DC)"}
          ASSIGN vLogErro           = YES
                 v_cod_usuar_corren = ''.
          RETURN ERROR.
       END.
       ELSE DO:
          IF CAN-FIND (FIRST tt-erros WHERE tt-erros.cod-erro = 4758) THEN DO: 
             {bcp/bc9105.i "4758" "Senha para o usu rio nÆo est  correta. (DC)"} 
             ASSIGN vLogErro           = YES
                    v_cod_usuar_corren = ''.
             RETURN ERROR.
          END.
          ELSE DO:
             IF CAN-FIND (FIRST tt-erros) THEN DO:
                {bcp/bc9105.i "202" "Problemas na autentica‡Æo do usu rio. (DC)"} 
                ASSIGN vLogErro           = YES
                       v_cod_usuar_corren = ''.
                RETURN ERROR.
             END.
          END.
       END.
       IF NOT VALID-HANDLE(wgbcapiwms) THEN
          Run bcp/bcapiwms.p Persistent Set wgbcapiwms No-error.

       RUN piValidaUsuario IN wgbcapiwms (INPUT ttWork.cod-usuario:SCREEN-VALUE IN FRAME {&Frame01Name},
                                          OUTPUT ttWork.cod-usuario).
                                          
       IF VALID-HANDLE(wgbcapiwms) THEN
           DELETE PROCEDURE wgbcapiwms NO-ERROR.
                                           
       ASSIGN vLogControlaLogin = YES.
    END.

    {bcp/bc9017.i1 ttWork.cod-usuario:SCREEN-VALUE IN FRAME {&Frame01Name}}

    IF NOT VALID-HANDLE(wgbosc079) THEN DO:
       RUN scbo/bosc079.p PERSISTENT SET wgbosc079 NO-ERROR.
    END.
    IF NOT VALID-HANDLE(wgbosc092) THEN DO:
       RUN scbo/bosc092.p PERSISTENT SET wgbosc092 NO-ERROR.
    END.
    IF vLogOk = NO THEN DO:
       ASSIGN vLogErro = YES.
       IF vLogControlaLogin = YES THEN
          ASSIGN v_cod_usuar_corren  = ''
                 v2_cod_usuar_corren = ''.

       {bcp/bc9105.i "101" "Usu rio Inv lido. (DC)"}
       RETURN ERROR.
    END.

    /* Valida existencia do usuario no WMS e retorna se ele tem ou nao permissao para utilizar coletor */
    RUN validaUsuario IN wgbosc079 (INPUT  ttWork.cod-usuario:SCREEN-VALUE IN FRAME {&Frame01Name},
                                    OUTPUT vLogUtilizaColetor,
                                    OUTPUT vLogAprovaFatura).
    IF RETURN-VALUE <> 'OK' THEN DO:
       ASSIGN vLogErro = YES.
       IF vLogControlaLogin THEN
          ASSIGN v_cod_usuar_corren  = ''
                 v2_cod_usuar_corren = ''.
       {bcp/bc9105.i "101" "Usu rio Inv lido. (WMS)"}
       RETURN ERROR.
    END.

    IF vLogUtilizaColetor = NO THEN DO:
       ASSIGN vLogErro = YES.
       IF vLogControlaLogin THEN
          ASSIGN v_cod_usuar_corren  = ''
                 v2_cod_usuar_corren = ''.
       {bcp/bc9105.i "102" "Usu rio sem permissÆo para utilizar Coletor. (WMS)"}
       RETURN ERROR.
    END.

    /* valida se existe equipamento, se e do tipo coletor e se esta ativo */
    RUN validaEquipColetor IN wgbosc092 (INPUT  ttWork.cod-coletor,
                                         OUTPUT iCodTipoColetor,
                                         OUTPUT vLogAtivo,
                                         OUTPUT vLogProcesso).
    IF RETURN-VALUE <> 'OK' THEN DO:
       ASSIGN vLogErro = YES.
       {bcp/bc9105.i "103" "Coletor Inv lido. (WMS)"}
       RETURN ERROR.
    END.

    IF vLogAtivo = NO THEN DO:
       ASSIGN vLogErro = YES.
       {bcp/bc9105.i "104" "Coletor Inativo. (WMS)"}
       RETURN ERROR.
    END.

    /* valida se existe equipamento, se e do tipo transportador e se esta ativo */
    RUN validaEquipTransportador In wgbosc092 (INPUT  ttWork.cod-equipamento,
                                               OUTPUT iCodTipoEquip,
                                               OUTPUT vLogAtivo,
                                               OUTPUT vLogProcesso).
    IF RETURN-VALUE <> 'OK' THEN DO:
       ASSIGN vLogErro = YES.
       {bcp/bc9105.i "105" "Equipto Inv lido. (WMS)"}
       RETURN ERROR.
    END.

    IF vLogAtivo = NO THEN DO:
       ASSIGN vLogErro = YES.
       {bcp/bc9105.i "106" "Equipto Inativo. (WMS)"}
       RETURN ERROR.
    END.

    /* Validacoes Frame 01 Fim    --- */
    ASSIGN {&TempTable}.cod-usuario     = ttWork.cod-usuario 
           {&TempTable}.cod-coletor     = ttWork.cod-coletor
           {&TempTable}.cod-equipamento = ttWork.cod-equipamento.

    If Valid-handle(wgbosc092) Then Delete Procedure wgbosc092.
    If Valid-handle(wgbosc079) Then Delete Procedure wgbosc079.

END PROCEDURE.

/*************************************************************************************************** 
** Esta procedure esta inicializando os campos da tela Frame02 com valores em branco              **
** Esta procedure eï executada pelo pre-processador {&TriggerBeforeFrame02}.                      **
****************************************************************************************************/
PROCEDURE InicializaCamposFrame02:   
    EMPTY TEMP-TABLE tt-emitente NO-ERROR.

    /* Validacoes Frame 02 Inicio --- */
    ASSIGN vLogErro    = NO
           vLogRetorno = NO.

    ASSIGN vOpcao = 0
           vOpcao:SCREEN-VALUE IN FRAME Frame02 = "0".
    
END PROCEDURE.

/*************************************************************************************************** 
** Esta procedure esta armazenando na temp-table {&Temp-Table} os valores recebidos por ttWork    **
** na tela Frame 02.                                                                              **
** Esta procedure eï executada pelo pre-processador {&TriggerAfterFrame02}.                       **
****************************************************************************************************/
PROCEDURE GravaCamposFrame02:

    ASSIGN INPUT FRAME Frame02 vOpcao.

    IF vOpcao <> 1 AND vOpcao <> 2 THEN DO:
        ASSIGN vLogErro = YES.
        {bcp/bc9105.i "201" "Op‡Æo inv lida. (DC)"}
        RETURN ERROR.
    END.
        
END PROCEDURE.

/*************************************************************************************************** 
** Esta procedure eï executada pelo pre-processador {&TriggerBeforeFrame03}.                      **
****************************************************************************************************/
PROCEDURE InicializaCamposFrame03:
     
    ASSIGN vLogErro  = NO.

    IF NOT VALID-HANDLE(wgbosc075) THEN DO:
        RUN scbo/bosc075.p PERSISTENT SET wgbosc075.
        RUN openQueryStatic IN wgbosc075 (INPUT "Main":U) NO-ERROR.
    END.

    IF vOpcao = 2 THEN DO:   
    
         /*  */
         DO ON ENDKEY UNDO, RETURN "ESC":
             
             ASSIGN ttWork.nro-docto = ''
                    ttWork.serie     = ''.
         
             DISP ttWork.nro-docto ttWork.serie WITH FRAME Frame05.
    
             UPDATE ttWork.nro-docto ttWork.serie WITH FRAME {&Frame05Name} .
    
             RUN piValidaNota.
             IF NOT vLogErro THEN
                 LEAVE.
         END.
    END.
    ELSE DO: 
        RUN piGetNotas.
    
        IF NOT CAN-FIND(FIRST tt-notas) THEN DO:
    
            CREATE tt-notas.
            ASSIGN tt-notas.nro-docto    = "NÆo existem notas."   
                   tt-notas.serie        = ""       
                   tt-notas.cod-emitente = 0
                   tt-notas.nat-operacao = ""
                   tt-notas.nome-abrev   = "".
        END.
    
        OPEN QUERY qry-notas FOR EACH tt-notas BY tt-notas.nro-docto.
    END.
    
  
END PROCEDURE.

/*************************************************************************************************** 
** Esta procedure esta armazenando na temp-table {&Temp-Table} os valores recebidos por ttWork    **
** na tela Frame 03.                                                                              **
** Esta procedure eï executada pelo pre-processador {&TriggerAfterFrame03}.                       **
****************************************************************************************************/
PROCEDURE GravaCamposFrame03:

    ASSIGN vLogErro = NO.

    IF vOpcao = 1 THEN DO: /*LISTA NOTAS*/

        RUN piVerificaDocConferido(INPUT tt-notas.nro-docto
                                  ,INPUT tt-notas.serie
                                  ,INPUT tt-notas.nat-operacao
                                  ,INPUT tt-notas.cod-emitente
                                  ,INPUT tt-notas.dt-trans).

        IF vLogErro THEN
           RETURN ERROR.

        RUN piGetItemNota(INPUT tt-notas.serie,       
                          INPUT tt-notas.nro-docto,  
                          INPUT tt-notas.cod-emitente,
                          INPUT tt-notas.nat-operacao).
    END.
    ELSE DO:

        RUN piVerificaDocConferido(INPUT ttWork.nro-docto
                                  ,INPUT ttWork.serie
                                  ,INPUT ttWork.nat-operacao
                                  ,INPUT ttWork.cod-emitente
                                  ,INPUT p-dt-trans).

        IF vLogErro THEN
           RETURN ERROR.

        RUN piGetItemNota(INPUT ttWork.serie,       
                          INPUT ttWork.nro-docto,  
                          INPUT ttWork.cod-emitente,
                          INPUT ttWork.nat-operacao).
    END.

END PROCEDURE.

/*************************************************************************************************** 
** Esta procedure eï executada pelo pre-processador {&TriggerBeforeFrame04}.                      **
****************************************************************************************************/
PROCEDURE InicializaCamposFrame04:
    ASSIGN vLogErro  = NO.

    OPEN QUERY qry-item-nota FOR EACH tt-item-nota BY tt-item-nota.sequencia.

END PROCEDURE.

/*************************************************************************************************** 
** Esta procedure esta armazenando na temp-table {&Temp-Table} os valores recebidos por ttWork    **
** na tela Frame 04.                                                                              **
** Esta procedure eï executada pelo pre-processador {&TriggerAfterFrame04}.                       **
****************************************************************************************************/
PROCEDURE GravaCamposFrame04:
    ASSIGN vLogErro   = NO.

    ASSIGN ttWork.cod-estabel  = tt-item-nota.cod-estabel  
           ttWork.cod-local    = tt-item-nota.cod-local    
           ttWork.cod-deposito = tt-item-nota.cod-deposito 
           ttWork.nro-docto    = tt-item-nota.nro-docto    
           ttWork.serie        = tt-item-nota.serie        
           ttWork.cod-emitente = tt-item-nota.cod-emitente 
           ttWork.nat-operacao = tt-item-nota.nat-operacao    
           ttWork.sequencia    = tt-item-nota.sequencia    
           ttWork.cod-item     = tt-item-nota.cod-item     
           ttWork.lote         = tt-item-nota.lote         
           ttWork.cod-refer    = tt-item-nota.cod-refer
           ttWork.dt-vali-lote = tt-item-nota.dt-vali-lote.

    IF tt-item-nota.cod-item = "Novo Item" THEN DO:
        ASSIGN ttWork.lNovo-item = YES.

        HIDE ALL NO-PAUSE.
        RUN bcp/bc9050h.p (INPUT TABLE ttWork,
                           INPUT p-Id-carga).
        HIDE ALL NO-PAUSE.
    END.
    ELSE DO:
        ASSIGN ttWork.lNovo-item = NO.

        HIDE ALL NO-PAUSE.
        RUN bcp/bc9050b.p (INPUT TABLE ttWork,
                           INPUT p-Id-carga).
        HIDE ALL NO-PAUSE.
    END.
    RETURN ERROR. /*para inicializar a Frame04 novamente*/


END PROCEDURE.

PROCEDURE piValidaNota:
    
    ASSIGN  vLogErro = NO.

    IF NOT VALID-HANDLE(wgboin089wm) THEN DO:
        RUN inbo/boin089wm.p PERSISTENT SET wgboin089wm.
        RUN openQueryStatic IN wgboin089wm (INPUT "Main":U) NO-ERROR.
    END.
    
    /*Valida Documento Informado e retorna Fornecedores*/
    EMPTY TEMP-TABLE tt-fornec-docto.
    RUN getFornecDoctos-DocumEst IN wgboin089wm(INPUT ttWork.nro-docto,
                                                INPUT ttWork.serie,
                                                OUTPUT TABLE tt-fornec-docto).
    IF RETURN-VALUE <> 'OK':U THEN DO:
        ASSIGN vLogErro = YES.
        {bcp/bc9105.i "201" "Documento Inv lido. (WMS)"}
        RETURN ERROR.
    END.

    ASSIGN i-conta-fornec = 0
           p-nome-abrev   = "".

    FOR EACH tt-fornec-docto:
        ASSIGN i-conta-fornec = i-conta-fornec + 1
               p-cod-emitente = tt-fornec-docto.cod-emitente
               p-nat-oper     = tt-fornec-docto.nat-operacao
               p-nome-abrev   = tt-fornec-docto.nome-abrev
               p-dt-trans     = tt-fornec-docto.data-transacao.
    END.

    IF i-conta-fornec > 1 THEN DO:
        HIDE ALL NO-PAUSE.
        RUN bcp/bc9050a.p (INPUT TABLE tt-fornec-docto,
                           OUTPUT p-cod-emitente,
                           OUTPUT p-nat-oper,
                           OUTPUT p-nome-abrev,
                           OUTPUT p-dt-trans).
        HIDE ALL NO-PAUSE.
        IF p-cod-emitente = 0 THEN DO:
            ASSIGN vLogErro = YES.
            {bcp/bc9105.i "202" "Nenhum fornecedor foi selecionado.(WMS)"}
            RETURN ERROR.
        END.
    END.
    
    ASSIGN ttWork.nat-operacao = p-nat-oper
           ttWork.cod-emitente = p-cod-emitente.

END PROCEDURE.

PROCEDURE piGetNotas:
    DEFINE VARIABLE cNomeAbrev AS CHARACTER          NO-UNDO.
    DEFINE VARIABLE lCriaWMS   AS LOGICAL INITIAL NO NO-UNDO.

    EMPTY TEMP-TABLE tt-notas NO-ERROR.

    FOR EACH docum-est NO-LOCK
       WHERE docum-est.log-2    = NO:  /*Nao Atualizado WMS*/
         /*AND docum-est.ce-atual = NO:*/ /*Nao Atualizado*/ 

        /*Verifica se o documento tem itens para os dep¢sitos WMS*/
        ASSIGN lCriaWMS = NO.
        FOR EACH item-doc-est NO-LOCK
           WHERE item-doc-est.serie-docto  = docum-est.serie-docto 
             AND item-doc-est.nro-docto    = docum-est.nro-docto   
             AND item-doc-est.cod-emitente = docum-est.cod-emitente
             AND item-doc-est.nat-operacao = docum-est.nat-operacao,
            EACH rat-lote NO-LOCK 
           WHERE rat-lote.nro-docto    = item-doc-est.nro-docto  
             AND rat-lote.serie-docto  = item-doc-est.serie-docto  
             AND rat-lote.cod-emitente = item-doc-est.cod-emitente 
             AND rat-lote.nat-operacao = item-doc-est.nat-operacao                      
             AND rat-lote.sequencia    = item-doc-est.sequencia:

             IF CAN-FIND(FIRST deposito NO-LOCK 
                         WHERE deposito.cod-depos    = rat-lote.cod-depos 
                           AND deposito.log-gera-wms = YES) THEN DO:

                ASSIGN lCriaWMS = YES.
                LEAVE.
             END.
        END.

        IF lCriaWMS = NO THEN
           NEXT.

        IF NOT CAN-FIND(FIRST tt-notas
                        WHERE tt-notas.nro-docto    = docum-est.nro-docto
                          AND tt-notas.serie        = docum-est.serie
                          AND tt-notas.cod-emitente = docum-est.cod-emitente
                          AND tt-notas.nat-operacao = docum-est.nat-operacao) THEN DO:
           
           RUN piBuscaEmitente(INPUT docum-est.cod-emitente
                              ,OUTPUT cNomeAbrev).
           
           CREATE tt-notas.
           ASSIGN tt-notas.nro-docto    = docum-est.nro-docto   
                  tt-notas.serie        = docum-est.serie       
                  tt-notas.cod-emitente = docum-est.cod-emitente
                  tt-notas.nat-operacao = docum-est.nat-operacao
                  tt-notas.dt-trans     = docum-est.dt-trans
                  tt-notas.nome-abrev   = cNomeAbrev.
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE piGetItemNota:
    DEFINE INPUT PARAMETER pSerie       LIKE item-doc-est.serie-docto  NO-UNDO.
    DEFINE INPUT PARAMETER pNroDocto    LIKE item-doc-est.nro-docto    NO-UNDO.
    DEFINE INPUT PARAMETER pCodEmitente LIKE item-doc-est.cod-emitente NO-UNDO.
    DEFINE INPUT PARAMETER pNatOper     LIKE item-doc-est.nat-operacao NO-UNDO.

    EMPTY TEMP-TABLE tt-item-nota NO-ERROR.

    IF NOT VALID-HANDLE(wgbosc047) THEN DO:
        RUN scbo/bosc047.p PERSISTENT SET wgbosc047.
        RUN openQueryStatic IN wgbosc047 (INPUT "Main":U) NO-ERROR.
    END.

    IF NOT VALID-HANDLE(wgbosc048) THEN DO:
        RUN scbo/bosc048.p PERSISTENT SET wgbosc048.
        RUN openQueryStatic IN wgbosc048 (INPUT "Main":U) NO-ERROR.
    END.

    FOR FIRST docum-est NO-LOCK
        WHERE docum-est.serie-docto  = pSerie       
          AND docum-est.nro-docto    = pNroDocto   
          AND docum-est.cod-emitente = pCodEmitente
          AND docum-est.nat-operacao = pNatOper,  
         EACH item-doc-est NO-LOCK
        WHERE item-doc-est.serie-docto  = docum-est.serie-docto  
          AND item-doc-est.nro-docto    = docum-est.nro-docto           
          AND item-doc-est.cod-emitente = docum-est.cod-emitente 
          AND item-doc-est.nat-operacao = docum-est.nat-operacao,    
         EACH rat-lote NO-LOCK 
        WHERE rat-lote.nro-docto    = item-doc-est.nro-docto  
          AND rat-lote.serie-docto  = item-doc-est.serie-docto  
          AND rat-lote.cod-emitente = item-doc-est.cod-emitente 
          AND rat-lote.nat-operacao = item-doc-est.nat-operacao                      
          AND rat-lote.sequencia    = item-doc-est.sequencia,
        FIRST deposito NO-LOCK 
        WHERE deposito.cod-depos    = rat-lote.cod-depos 
          AND deposito.log-gera-wms = YES
        BREAK BY rat-lote.cod-depos:

       IF NOT CAN-FIND(FIRST tt-item-nota) THEN DO:

            CREATE tt-item-nota.
            ASSIGN tt-item-nota.cod-estabel      = docum-est.cod-estabel
                   tt-item-nota.cod-local        = ""
                   tt-item-nota.cod-deposito     = ""
                   tt-item-nota.nro-docto        = item-doc-est.nro-docto  
                   tt-item-nota.serie            = item-doc-est.serie-docto   
                   tt-item-nota.cod-emitente     = item-doc-est.cod-emitente
                   tt-item-nota.nat-operacao     = item-doc-est.nat-operacao   
                   tt-item-nota.sequencia        = 999
                   tt-item-nota.cod-item         = "Novo Item"
                   tt-item-nota.lote             = ""
                   tt-item-nota.cod-refer        = ""
                   tt-item-nota.dt-vali-lote     = ?. 
       END.

       IF NOT CAN-FIND(FIRST tt-item-nota
                       WHERE tt-item-nota.serie        = item-doc-est.serie-docto 
                         AND tt-item-nota.nro-docto    = item-doc-est.nro-docto   
                         AND tt-item-nota.cod-emitente = item-doc-est.cod-emitente
                         AND tt-item-nota.nat-operacao = item-doc-est.nat-operacao   
                         AND tt-item-nota.sequencia    = item-doc-est.sequencia) THEN DO:

            ASSIGN c-cod-local-wms = "".
            RUN getLocalDepositoEstab in wgbosc047 (INPUT  docum-est.cod-estabel,  
                                                    INPUT  rat-lote.cod-depos,     
                                                    OUTPUT c-cod-local-wms).  
        
            IF  c-cod-local-wms = ""
            OR  c-cod-local-wms = ? THEN
                RUN getLocalDeposito IN wgbosc048 (INPUT  docum-est.cod-estabel,
                                                   INPUT  rat-lote.cod-depos,
                                                   OUTPUT c-cod-local-wms).

            IF c-cod-local-wms = ""
            OR c-cod-local-wms = ? THEN
                RUN getLocalDepositoClasse(INPUT docum-est.cod-estabel, 
                                           INPUT rat-lote.cod-depos,
                                           OUTPUT c-cod-local-wms).
 
            CREATE tt-item-nota.
            ASSIGN tt-item-nota.cod-estabel      = docum-est.cod-estabel
                   tt-item-nota.cod-local        = c-cod-local-wms
                   tt-item-nota.cod-deposito     = rat-lote.cod-depos
                   tt-item-nota.nro-docto        = item-doc-est.nro-docto  
                   tt-item-nota.serie            = item-doc-est.serie-docto   
                   tt-item-nota.cod-emitente     = item-doc-est.cod-emitente
                   tt-item-nota.nat-operacao     = item-doc-est.nat-operacao   
                   tt-item-nota.sequencia        = item-doc-est.sequencia
                   tt-item-nota.cod-item         = item-doc-est.it-codigo 
                   tt-item-nota.lote             = rat-lote.lote 
                   tt-item-nota.cod-refer        = rat-lote.cod-refer
                   tt-item-nota.dt-vali-lote     = rat-lote.dt-vali-lote. 

       END.       
    END.

    
    RETURN "OK":U.
END PROCEDURE.

PROCEDURE piBuscaEmitente:
    DEFINE INPUT  PARAMETER pCodEmit AS INTEGER NO-UNDO.
    DEFINE OUTPUT PARAMETER pNomeAbrev AS CHARACTER NO-UNDO.

    FIND FIRST tt-emitente 
         WHERE tt-emitente.cod-emitente = pCodEmit NO-ERROR.
    IF NOT AVAIL tt-emitente THEN DO:

       FOR FIRST emitente FIELDS(cod-emitente nome-abrev) NO-LOCK
           WHERE emitente.cod-emitente = docum-est.cod-emitente:

           CREATE tt-emitente.
           ASSIGN tt-emitente.cod-emitente = emitente.cod-emitente
                  tt-emitente.nome-abrev   = emitente.nome-abrev

                  pNomeAbrev = tt-emitente.nome-abrev.
       END.
    END.
    ELSE 
       ASSIGN pNomeAbrev = tt-emitente.nome-abrev.

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE piVerificaDocConferido:
    DEFINE INPUT PARAMETER pNroDocto    LIKE docum-est.nro-docto    NO-UNDO.
    DEFINE INPUT PARAMETER pSerie       LIKE docum-est.serie-docto  NO-UNDO.
    DEFINE INPUT PARAMETER pNatOper     LIKE docum-est.nat-operacao NO-UNDO.
    DEFINE INPUT PARAMETER pCodEmitente LIKE docum-est.cod-emitente NO-UNDO.
    DEFINE INPUT PARAMETER pDtTrans     LIKE docum-est.dt-trans     NO-UNDO.

    /*Valida documento totalmente conferido*/
    RUN getStatusConferenciaCarga-DocumEst IN wgbosc075(INPUT pNroDocto,
                                                        INPUT pSerie,
                                                        INPUT pNatOper,
                                                        INPUT pCodEmitente,
                                                        INPUT pDtTrans,
                                                        OUTPUT p-Log-conf-ok,
                                                        OUTPUT p-Id-carga).

    IF p-Log-conf-ok = YES THEN DO:
        /* Projeto Internacional -- Traducao de DISPLAY. Validar e verificar possibilidade de colocar em FRAME */
        DEFINE VARIABLE c-lbl-liter-docto-totalmente AS CHARACTER FORMAT "X(18)" NO-UNDO.
        {utp/ut-liter.i "Docto_totalmente" *}
        ASSIGN c-lbl-liter-docto-totalmente = TRIM(RETURN-VALUE).
        DEFINE VARIABLE c-lbl-liter-conferido AS CHARACTER FORMAT "X(12)" NO-UNDO.
        {utp/ut-liter.i "conferido" *}
        ASSIGN c-lbl-liter-conferido = TRIM(RETURN-VALUE).
        DEFINE VARIABLE c-lbl-liter-deseja-reabrir-a AS CHARACTER FORMAT "X(19)" NO-UNDO.
        {utp/ut-liter.i "Deseja_reabrir_a" *}
        ASSIGN c-lbl-liter-deseja-reabrir-a = TRIM(RETURN-VALUE).
        DEFINE VARIABLE c-lbl-liter-contagem AS CHARACTER FORMAT "X(11)" NO-UNDO.
        {utp/ut-liter.i "contagem?" *}
        ASSIGN c-lbl-liter-contagem = TRIM(RETURN-VALUE).
        DEFINE VARIABLE c-lbl-liter-1sim-2nao AS CHARACTER FORMAT "X(13)" NO-UNDO.
        {utp/ut-liter.i "1=Sim_2=NÆo" *}
        ASSIGN c-lbl-liter-1sim-2nao = TRIM(RETURN-VALUE).
        DISP c-lbl-liter-docto-totalmente       At ROW 01 COL 01 NO-LABEL
             c-lbl-liter-conferido + '.'        At ROW 02 COL 01 NO-LABEL
             c-lbl-liter-deseja-reabrir-a + ' ' AT ROW 03 COL 01 NO-LABEL
             c-lbl-liter-contagem               AT ROW 04 COL 01 NO-LABEL
             c-lbl-liter-1sim-2nao              AT ROW 05 COL 01 NO-LABEL WITH FRAME f-conf FONT 2 SIZE 20 BY 8 NO-BOX.
        UPDATE vLogAnswer AT ROW 05 COL 13 NO-LABEL FORMAT '1/2':U WITH FRAME f-conf FONT 2 SIZE 20 BY 8.
        IF vLogAnswer = YES THEN DO:
           RUN reabreContagemWMS-DocumEst IN wgboin089wm (INPUT pNroDocto,
                                                          INPUT pSerie,
                                                          INPUT pNatOper,
                                                          INPUT pCodEmitente,
                                                          INPUT 0, /*sequencia do item*/
                                                          OUTPUT TABLE RowErrors).
           IF RETURN-VALUE <> 'OK':U THEN DO:
               RUN getrowErrors IN wgboin089wm (OUTPUT TABLE RowErrors).
               ASSIGN vLogErro = YES.
               FOR EACH RowErrors:
                   ASSIGN ErrorDescription = ErrorDescription + "(WMS)":U.
                   {bcp/bc9015.i2 STRING(ErrorNumber) STRING(ErrorDescription)}
               END.
           END.
        END.
        ELSE DO:
           ASSIGN vLogErro = YES.
        END.
    END.

END PROCEDURE.

PROCEDURE getLocalDepositoClasse:
    DEFINE INPUT PARAMETER pCodEstabel LIKE wm-docto.cod-estabel  NO-UNDO.
    DEFINE INPUT PARAMETER pCodDepos   LIKE wm-local.cod-deposito NO-UNDO.
    DEFINE OUTPUT PARAMETER pCodLocal  LIKE wm-local.cod-local    NO-UNDO.

    FIND FIRST wm-local-depos-classe NO-LOCK
         WHERE wm-local-depos-classe.cod-estabel = pCodEstabel
           AND wm-local-depos-classe.cod-depos   = pCodDepos NO-ERROR.
    ASSIGN pCodLocal = IF AVAIL wm-local-depos-classe 
                           THEN wm-local-depos-classe.cod-local ELSE "".

END PROCEDURE.
