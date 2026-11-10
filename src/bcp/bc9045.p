/*:T*******************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC9045 2.00.00.008 } /*** "010008" 24/07/2024 11:01:56  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i BC9045 MBC}
&ENDIF

{include/i_dbvers.i}  /* versao das bases e bases instaladas */

/* Definicao global do nome da transacao ---                */
&global-define ProgramName BC9045
&global-define TempTable tt-conf-rec-fisico
{bcp/bc9045.i " "}
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
    FIELD nro-docto        AS CHARACTER FORMAT 'x(16)':U           LABEL 'Nr NF'
    FIELD serie            AS CHARACTER FORMAT 'x(05)':U           LABEL 'SÇrie'.
CREATE ttWork.

DEFINE TEMP-TABLE tt-fornec-docto NO-UNDO
    FIELD nro-docto        AS CHARACTER FORMAT "x(16)":U
    FIELD serie            AS CHARACTER FORMAT "X(05)":U
    FIELD cod-emitente     AS INTEGER   FORMAT ">>>>>>>>9":U
    FIELD tipo-nota        AS INTEGER   FORMAT ">9":U
    FIELD nome-abrev       AS CHARACTER FORMAT "x(12):U"
    FIELD data-transacao   AS DATE.
 
/* ************************** Definitions ******************************** */
DEFINE VARIABLE vLogOk                 AS LOGICAL   INIT NO           NO-UNDO.
DEFINE VARIABLE vcod-senha             AS CHARACTER FORMAT 'x(18)':U  NO-UNDO.
DEFINE VARIABLE vCodSenha              AS CHARACTER FORMAT 'x(12)':U  NO-UNDO.
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
DEFINE VARIABLE p-tipo-nota            AS INTEGER                     NO-UNDO.
DEFINE VARIABLE p-dt-trans             AS DATE                        NO-UNDO.
DEFINE VARIABLE p-embarque             AS INTEGER                     NO-UNDO.
DEFINE VARIABLE p-resumo               AS INTEGER                     NO-UNDO.
DEFINE VARIABLE p-pedido               AS CHARACTER                   NO-UNDO.
DEFINE VARIABLE p-nome-abrev           AS CHARACTER                   NO-UNDO.
DEFINE VARIABLE p-retornou-esc         AS LOGICAL     NO-UNDO.
DEFINE VARIABLE p-Log-conf-ok          AS LOGICAL     NO-UNDO.
DEFINE VARIABLE p-Id-carga             LIKE wm-carga.id-carga  NO-UNDO.
DEFINE VARIABLE vLogAnswer             AS LOGICAL     INIT NO      NO-UNDO.
DEFINE VARIABLE p-finaliza             AS LOGICAL     NO-UNDO.

DEFINE VARIABLE wgbosc079          AS HANDLE                       NO-UNDO.
DEFINE VARIABLE wgbosc092          AS HANDLE                       NO-UNDO.
DEFINE VARIABLE wgboin089wm        AS HANDLE                       NO-UNDO.
DEFINE VARIABLE wgbosc075          AS HANDLE                       NO-UNDO.
DEFINE VARIABLE wgbcapiwms         AS HANDLE                       NO-UNDO. 

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
&global-define Frame01Defs   'Conf. Rec. F°sico   '                             At Row 01 Col 01          ~
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
&global-define Frame02Defs   'Conf. Rec. F°sico   '                             At Row 01 Col 01          ~
                             '--------------------'                             At Row 02 Col 01          ~
                             'Nr.NF:'                                           AT ROW 03 COL 01          ~
                             ttWork.nro-docto                                   AT ROW 04 COL 01 NO-LABEL ~
                             'SÇrie:'                                           AT ROW 05 COL 01          ~
                             ttWork.serie                                       AT ROW 05 COL 07 NO-LABEL
&global-define Frame02Repeat YES

/* Definicao dos campos a serem recebidos ---               */
&global-define Update01Fields ttWork.cod-usuario WHEN ttWork.cod-usuario = '' ~
                              vCodSenha          WHEN ttWork.cod-usuario = '' ~
                              ttWork.cod-coletor ~
                              ttWork.cod-equipamento
&global-define Update02Fields ttWork.nro-docto ~
                              ttWork.serie

/* Definicao das trigger de interacao com a tela ---        */ 
&global-define TriggerBeforeFrame01 Run InicializaCamposFrame01. IF vLogSai = YES THEN DO: LEAVE _frame01. END.
&global-define TriggerBeforeFrame02 Run InicializaCamposFrame02.

&global-define TriggerAfterFrame01  Run GravaCamposFrame01.
&global-define TriggerAfterFrame02  Run GravaCamposFrame02.

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
                            ON 'ESC':U OF Frame Frame02 ~
                            DO:                         ~
                                ASSIGN vlogerro = YES.  ~
                                Return 'ESC':U.         ~
                            END. ~
                            ON 'enter':U OF ttWork.cod-coletor IN Frame Frame01             ~
                            DO:                                                             ~
                                APPLY 'entry':U TO ttWork.cod-equipamento IN FRAME Frame01. ~
                                RETURN NO-APPLY.                                            ~
                            END.                                                            ~
                            ON 'enter':U OF ttWork.nro-docto IN Frame Frame02             ~
                            DO:                                                             ~
                                APPLY 'entry':U TO ttWork.serie IN FRAME Frame02.       ~
                                RETURN NO-APPLY.                                            ~
                            END.

{bcp/bc9100.i} /* Gerador da interface caracter do coleta de dados */
{bcp/bc9101.i} /* Procedure de atualizacao da transacao            */

PROCEDURE InicializaCamposFrame01:
   IF v_cod_usuar_corren <> '' THEN DO: 
      ASSIGN vCodSenha:BLANK IN FRAME {&Frame01Name}                 = NO
             ttWork.cod-usuario:SCREEN-VALUE IN FRAME {&Frame01Name} = v_cod_usuar_corren
             ttWork.cod-usuario                                      = v_cod_usuar_corren
             vCodSenha                                               = '****************':U 
             vCodSenha:SCREEN-VALUE IN FRAME {&Frame01Name}          = '****************':U. 
      IF v_cod-coletor_corren <> '' AND v_cod-equipamento_corren <> '' THEN DO:
         ASSIGN ttWork.cod-coletor:SCREEN-VALUE IN FRAME {&Frame01Name}     = v_cod-coletor_corren
                ttWork.cod-coletor     = v_cod-coletor_corren
                ttWork.cod-equipamento:SCREEN-VALUE IN FRAME {&Frame01Name} = v_cod-equipamento_corren
                ttWork.cod-equipamento = v_cod-equipamento_corren.
      END.
   END.
   ELSE DO:
      ASSIGN vCodSenha:BLANK IN FRAME {&Frame01Name}                 = YES
             ttWork.cod-usuario:SCREEN-VALUE IN FRAME {&Frame01Name} = '' 
             ttWork.cod-usuario                                      = '' 
             vCodSenha                                               = ''  
             vCodSenha:SCREEN-VALUE IN FRAME {&Frame01Name}          = ''.
   END.
END PROCEDURE.

PROCEDURE GravaCamposFrame01:
   /* Validacoes Frame 01 Inicio --- */
   ASSIGN vLogErro          = NO
          vLogControlaLogin = NO.

   IF v_cod_usuar_corren <> "" THEN
      ASSIGN ttWork.cod-usuario = v_cod_usuar_corren.
   ELSE
      ASSIGN INPUT FRAME {&Frame01Name} ttWork.cod-usuario.

   IF v2_cod_usuar_corren = '' THEN DO:
      EMPTY TEMP-TABLE tt-erros.

      login:
      DO ON ERROR  UNDO login, LEAVE login
      ON QUIT      UNDO login, LEAVE login
      ON STOP      UNDO login, LEAVE login
      ON ENDKEY    UNDO login, LEAVE login:
         RUN btb/btapi910za.p (INPUT ttWork.cod-usuario:SCREEN-VALUE IN FRAME {&Frame01Name}, 
                               INPUT vCodSenha,
                               OUTPUT TABLE tt-erros) NO-ERROR. 
      END. 
      IF CAN-FIND (FIRST tt-erros WHERE tt-erros.cod-erro = 4753) THEN DO:
         {bcp/bc9105.i "4753" "Usu†rio n∆o encontrado. (DC)"}
         ASSIGN vLogErro           = YES
                v_cod_usuar_corren = ''.
         RETURN ERROR.
      END.
      ELSE DO:
         IF CAN-FIND (FIRST tt-erros WHERE tt-erros.cod-erro = 4758) THEN DO: 
            {bcp/bc9105.i "4758" "Senha para o usu†rio n∆o est† correta. (DC)"} 
            ASSIGN vLogErro           = YES
                   v_cod_usuar_corren = ''.
            RETURN ERROR.
         END.
         ELSE DO:
            IF CAN-FIND (FIRST tt-erros) THEN DO:
               {bcp/bc9105.i "202" "Problemas na autenticaá∆o do usu†rio. (DC)"} 
               ASSIGN vLogErro           = YES
                      v_cod_usuar_corren = ''.
               RETURN ERROR.
            END.
         END.
      END.
      IF NOT VALID-HANDLE(wgbcapiwms) THEN
         RUN bcp/bcapiwms.p PERSISTENT SET wgbcapiwms NO-ERROR.

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

      {bcp/bc9105.i "101" "Usu†rio Inv†lido. (DC)"}
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
      {bcp/bc9105.i "101" "Usu†rio Inv†lido. (WMS)"}
      RETURN ERROR.
   END.

   IF vLogUtilizaColetor = NO THEN DO:
      ASSIGN vLogErro = YES.
      IF vLogControlaLogin THEN
         ASSIGN v_cod_usuar_corren  = ''
                v2_cod_usuar_corren = ''.
      {bcp/bc9105.i "102" "Usu†rio sem permiss∆o para utilizar Coletor. (WMS)"}
      RETURN ERROR.
   END.

   /* valida se existe equipamento, se e do tipo coletor e se esta ativo */
   RUN validaEquipColetor IN wgbosc092 (INPUT  ttWork.cod-coletor,
                                        OUTPUT iCodTipoColetor,
                                        OUTPUT vLogAtivo,
                                        OUTPUT vLogProcesso).
   IF RETURN-VALUE <> 'OK' THEN DO:
      ASSIGN vLogErro = YES.
      {bcp/bc9105.i "103" "Coletor Inv†lido. (WMS)"}
      RETURN ERROR.
   END.

   IF vLogAtivo = NO THEN DO:
      ASSIGN vLogErro = YES.
      {bcp/bc9105.i "104" "Coletor Inativo. (WMS)"}
      RETURN ERROR.
   END.

   /* valida se existe equipamento, se e do tipo transportador e se esta ativo */
   RUN validaEquipTransportador IN wgbosc092 (INPUT  ttWork.cod-equipamento,
                                              OUTPUT iCodTipoEquip,
                                              OUTPUT vLogAtivo,
                                              OUTPUT vLogProcesso).
   IF RETURN-VALUE <> 'OK' THEN DO:
      ASSIGN vLogErro = YES.
      {bcp/bc9105.i "105" "Equipto Inv†lido. (WMS)"}
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

   IF VALID-HANDLE(wgbosc092) THEN
      DELETE PROCEDURE wgbosc092.
      
   IF VALID-HANDLE(wgbosc079) THEN
      DELETE PROCEDURE wgbosc079.

END PROCEDURE.

PROCEDURE InicializaCamposFrame02:   
   ASSIGN vLogErro  = NO.
   IF NOT VALID-HANDLE(wgboin089wm) THEN DO:
      RUN inbo/boin089wm.p PERSISTENT SET wgboin089wm.
      RUN openQueryStatic IN wgboin089wm (INPUT "Main":U) NO-ERROR.
   END.                  

   IF NOT VALID-HANDLE(wgbosc075) THEN DO:
      RUN scbo/bosc075.p PERSISTENT SET wgbosc075.
      RUN openQueryStatic IN wgbosc075 (INPUT "Main":U) NO-ERROR.
   END.                  

   ASSIGN ttWork.nro-docto = ''
          ttWork.serie     = ''.

   DISP ttWork.nro-docto
        ttWork.serie
      WITH FRAME Frame02.
       
   APPLY 'leave':U TO ttWork.nro-docto IN FRAME Frame02. 

END PROCEDURE.

PROCEDURE GravaCamposFrame02:
   ASSIGN  vLogErro = NO.
   ASSIGN INPUT FRAME  Frame02 ttWork.nro-docto
                               ttWork.serie.
   /*Valida Documento Informado e retorna Fornecedores*/
   EMPTY TEMP-TABLE tt-fornec-docto. 
   RUN getFornecDoctos IN wgboin089wm(INPUT ttWork.nro-docto,
                                      INPUT ttWork.serie,
                                      OUTPUT TABLE tt-fornec-docto).
   IF RETURN-VALUE <> 'OK':U THEN DO:
      ASSIGN vLogErro = YES.
      {bcp/bc9105.i "201" "Documento Inv†lido. (WMS)"}
      RETURN ERROR.
   END.

   ASSIGN i-conta-fornec = 0
          p-embarque     = 0
          p-resumo       = 0
          p-pedido       = ""
          p-nome-abrev   = "".

   FOR EACH tt-fornec-docto:
      ASSIGN i-conta-fornec = i-conta-fornec + 1
             p-cod-emitente = tt-fornec-docto.cod-emitente  
             p-tipo-nota    = tt-fornec-docto.tipo-nota     
             p-nome-abrev   = tt-fornec-docto.nome-abrev    
             p-dt-trans     = tt-fornec-docto.data-transacao.
   END.

   IF i-conta-fornec > 1 THEN DO:
      HIDE ALL NO-PAUSE.
      RUN bcp/bc9045a.p (INPUT TABLE tt-fornec-docto,
                         OUTPUT p-cod-emitente,
                         OUTPUT p-tipo-nota,   
                         OUTPUT p-nome-abrev,  
                         OUTPUT p-dt-trans).
      HIDE ALL NO-PAUSE.
      IF p-cod-emitente = 0 THEN DO:
         ASSIGN vLogErro = YES.
         {bcp/bc9105.i "202" "Nenhum fornecedor foi selecionado.(WMS)"}
         RETURN ERROR.     
      END.                      
   END.

   /*Valida documento totalmente conferido*/
   RUN getStatusConferenciaCarga IN wgbosc075(INPUT ttWork.nro-docto,   
                                              INPUT ttWork.serie,       
                                              INPUT p-tipo-nota,  
                                              INPUT p-cod-emitente,
                                              INPUT p-dt-trans,    
                                              OUTPUT p-Log-conf-ok,  
                                              OUTPUT p-Id-carga).
   IF p-Log-conf-ok = YES THEN DO:
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
      {utp/ut-liter.i "1=Sim_2=N∆o" *}
      ASSIGN c-lbl-liter-1sim-2nao = TRIM(RETURN-VALUE).
      
      DISP c-lbl-liter-docto-totalmente       AT ROW 01 COL 01 NO-LABEL
           c-lbl-liter-conferido + '.'        AT ROW 02 COL 01 NO-LABEL
           c-lbl-liter-deseja-reabrir-a + ' ' AT ROW 03 COL 01 NO-LABEL
           c-lbl-liter-contagem               AT ROW 04 COL 01 NO-LABEL
           c-lbl-liter-1sim-2nao              AT ROW 05 COL 01 NO-LABEL
         WITH FRAME f-conf FONT 2 SIZE 20 BY 8 NO-BOX.
          
      UPDATE vLogAnswer AT ROW 05 COL 13 NO-LABEL FORMAT '1/2':U WITH FRAME f-conf FONT 2 SIZE 20 BY 8. 
      IF vLogAnswer = YES THEN DO:
         RUN reabreContagemWMS IN wgboin089wm (INPUT ttWork.nro-docto,   
                                               INPUT ttWork.serie,       
                                               INPUT p-tipo-nota,   
                                               INPUT p-cod-emitente,
                                               INPUT 0, /*sequencia do item*/
                                               OUTPUT TABLE RowErrors).
         IF RETURN-VALUE <> 'OK':U THEN DO:
            RUN getrowErrors IN wgboin089wm (OUTPUT TABLE RowErrors).
            ASSIGN vLogErro = YES.
            FOR EACH RowErrors:
               ASSIGN ErrorDescription = ErrorDescription + "(WMS)":U.
               {bcp/bc9015.i2 STRING(ErrorNumber) STRING(ErrorDescription)}
            END.
            RETURN ERROR.
         END.
      END.
      ELSE DO:
         ASSIGN vLogErro = YES.
         RETURN ERROR.         
      END.
   END.    

   ASSIGN p-finaliza = NO.

   DO WHILE p-finaliza = NO: 
      HIDE ALL NO-PAUSE.
      RUN bcp/bc9045b.p (INPUT ttWork.cod-usuario,
                         INPUT ttWork.cod-coletor, 
                         INPUT ttWork.cod-equipamento,
                         INPUT ttWork.nro-docto,
                         INPUT ttWork.serie,
                         INPUT p-tipo-nota,
                         INPUT p-cod-emitente,
                         INPUT p-Id-carga,
                         OUTPUT p-finaliza).
      HIDE ALL NO-PAUSE.                                                    
   END. 
END PROCEDURE.

FINALLY:
   IF NOT lMenu AND THIS-PROCEDURE:PERSISTENT THEN
      DELETE PROCEDURE THIS-PROCEDURE.
  
   RETURN 'OK':U.
END FINALLY.
