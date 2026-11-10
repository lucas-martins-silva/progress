/*:T*******************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC9046 2.00.00.007 } /*** "010007" 25/07/2024 08:50:14 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i BC9046 MBC}
&ENDIF

{include/i_dbinst.i}

&GLOBAL-DEFINE ProgramName BC9046
&GLOBAL-DEFINE TempTable tt-confirma
&GLOBAL-DEFINE FrameSize 20 BY 8
&GLOBAL-DEFINE ErrorDisplaySeconds 3

{bcp/bc9046.i}
{scbo/bosc047.i tt-local}
{scbo/bosc070.i tt-docto-transf-depos}
{utp/utapi009.i}
{bcp/bc9048.i1} /* definicao variaveis menu padrao */
DEFINE VARIABLE l-menu-padrao AS LOGICAL INITIAL YES NO-UNDO.
DEFINE VARIABLE wgbcapiwms    AS HANDLE              NO-UNDO. 

DEFINE TEMP-TABLE ttWork NO-UNDO LIKE tt-confirma.
CREATE ttWork.

/**************************** FRAME 01 ****************************/
&GLOBAL-DEFINE Frame01Name   Frame01
&GLOBAL-DEFINE Frame01Defs   'Conf. Transf. WMS '   AT ROW 01 COLUMN 01             ~
                             '------------------'   AT ROW 02 COLUMN 01             ~
                             'Usr:'                 AT ROW 03 COLUMN 01             ~
                             ttWork.cod-usuario     AT ROW 03 COLUMN 05 NO-LABEL FORMAT "x(25)"  VIEW-AS FILL-IN SIZE 15 BY 0.88   ~
                             'Sen:'                 AT ROW 04 COLUMN 01             ~
                             vcod-senha             AT ROW 04 COLUMN 05 NO-LABEL FORMAT "x(18)"  VIEW-AS FILL-IN SIZE 15 BY 0.88   ~
                             'Col:'                 AT ROW 05 COLUMN 01             ~
                             ttWork.cod-coletor     AT ROW 05 COLUMN 05 NO-LABEL    ~
                             'Equ:'                 AT ROW 06 COLUMN 01             ~
                             ttWork.cod-equipamento AT ROW 06 COLUMN 05 NO-LABEL
&GLOBAL-DEFINE Frame01Repeat NO
&GLOBAL-DEFINE Update01Fields ttWork.cod-usuario WHEN ttWork.cod-usuario = ''   ~
                              vcod-senha         WHEN ttWork.cod-usuario = ''   ~
                              ttWork.cod-coletor                                ~
                              ttWork.cod-equipamento
&GLOBAL-DEFINE TriggerBeforeFrame01 RUN InicializaCamposFrame01. IF vLogSai THEN LEAVE _frame01.
&GLOBAL-DEFINE TriggerAfterFrame01  RUN GravaCamposFrame01.      IF vLogSai THEN LEAVE _frame01.

/**************************** FRAME 02 ****************************/
&GLOBAL-DEFINE Frame02Name   Frame02
&GLOBAL-DEFINE Frame02Defs   'Conf. Transf. WMS'    AT ROW 01 COLUMN 01          ~
                             '------------------'   AT ROW 02 COLUMN 01          ~
                             'Estab:'               AT ROW 03 COLUMN 01          ~
                              ttWork.cod-estabel    AT ROW 03 COLUMN 08 NO-LABEL ~
                             'Local:'               AT ROW 04 COLUMN 01          ~
                              ttWork.cod-local      AT ROW 04 COLUMN 08 NO-LABEL ~
                             'Depos:'               AT ROW 05 COLUMN 01          ~
                              ttWork.cod-depos      AT ROW 05 COLUMN 08 NO-LABEL
&GLOBAL-DEFINE Frame02repeat NO
&GLOBAL-DEFINE Update02Fields ttWork.cod-estabel ~
                              ttWork.cod-local ~
                              ttWork.cod-depos
&GLOBAL-DEFINE TriggerAfterFrame02  RUN GravaCamposFrame02. IF vLogSai THEN LEAVE _frame02.

/**************************** FRAME 03 ****************************/
&GLOBAL-DEFINE Frame03Name   Frame03
&GLOBAL-DEFINE Frame03Defs   'Conf. Transf. WMS'    AT ROW 01 COLUMN 01          ~
                             '------------------'   AT ROW 02 COLUMN 01          ~
                             'Documento:'           AT ROW 03 COLUMN 01          ~
                              ttWork.num-documento  AT ROW 04 COLUMN 01 NO-LABEL ~
                             'Seleciona: 888888'    AT ROW 08 COLUMN 01
&GLOBAL-DEFINE Frame03repeat NO
&GLOBAL-DEFINE Update03Fields ttWork.num-documento
&GLOBAL-DEFINE TriggerBeforeFrame03 RUN InicializaCamposFrame03.
&GLOBAL-DEFINE TriggerAfterFrame03  RUN GravaCamposFrame03. IF vLogSai THEN LEAVE _frame03.

&GLOBAL-DEFINE UserTriggers ON ENTRY OF ttWork.cod-coletor IN FRAME {&Frame01Name} ~
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
                            ON 'ESC':U OF FRAME frame01 DO: ~
                                ASSIGN vLogErro = YES       ~
                                       vLogSai  = YES       ~
                                       vLogFinaliza = YES   ~
                                       vLogCancela = YES.   ~
                                RETURN 'NOK':U.             ~
                            END.

&GLOBAL-DEFINE ActiveObject1 wgbosc079
&GLOBAL-DEFINE ActiveObject2 wgbosc092
&GLOBAL-DEFINE ActiveObject3 h-bosc047
&GLOBAL-DEFINE ActiveObject4 h-boin084
&GLOBAL-DEFINE ActiveObject5 h-bosc070
&GLOBAL-DEFINE ActiveObject6 wgbcapiwms

{bcp/bc9100.i}
{bcp/bc9101.i}

PROCEDURE InicializaCamposFrame01:

   IF RETURN-VALUE = 'NOK':U THEN DO:
      ASSIGN vLogErro     = YES
             vLogSai      = YES
             vLogFinaliza = YES
             vLogCancela  = YES.
      HIDE ALL NO-PAUSE.
      RETURN ERROR.
   END.

   ASSIGN vLogErro     = NO
          vLogSai      = NO
          vLogFinaliza = NO.

   EMPTY TEMP-TABLE ttWork.

   CREATE ttWork.

   IF v_cod_usuar_corren <> '' THEN DO: 
      ASSIGN vcod-senha:BLANK IN FRAME frame01 = NO
             ttWork.cod-usuario:SCREEN-VALUE IN FRAME frame01 = v_cod_usuar_corren
             ttWork.cod-usuario                               = v_cod_usuar_corren
             vcod-senha                                       = '****************':U /* login autom†tico */
             vcod-senha:SCREEN-VALUE IN FRAME frame01         = '****************':U. /* login autom†tico */
      IF v_cod-coletor_corren <> '' AND v_cod-equipamento_corren <> '' THEN DO:
         ASSIGN ttWork.cod-coletor:SCREEN-VALUE IN FRAME {&Frame01Name}     = v_cod-coletor_corren
                ttWork.cod-coletor     = v_cod-coletor_corren
                ttWork.cod-equipamento:SCREEN-VALUE IN FRAME {&Frame01Name} = v_cod-equipamento_corren
                ttWork.cod-equipamento = v_cod-equipamento_corren.
      END.
   END.
   ELSE DO:
      ASSIGN vcod-senha:BLANK IN FRAME frame01 = YES
             ttWork.cod-usuario:SCREEN-VALUE IN FRAME frame01 = '' 
             ttWork.cod-usuario = ''
             vcod-senha = ''  
             vcod-senha:SCREEN-VALUE IN FRAME frame01 = ''.
   END.

   RETURN "OK":U.

END PROCEDURE.

PROCEDURE GravaCamposFrame01:

   ASSIGN vLogErro          = NO
          vLogSai           = NO
          vLogFinaliza      = NO
          vLogErro          = NO
          vLogControlaLogin = NO.

   /* VALIDAÄAO USUµRIO */
   IF INPUT FRAME frame01 ttWork.cod-usuario = '' THEN DO:
      ASSIGN vLogErro = YES.
      {bcp/bc9105.i "201" "Usu†rio Inv†lido (DC)"}
   END. 
   
   IF v2_cod_usuar_corren = '' THEN DO:
      
      EMPTY TEMP-TABLE tt-erros.

      login:
      DO ON ERROR  UNDO login, LEAVE login
         ON QUIT   UNDO login, LEAVE login
         ON STOP   UNDO login, LEAVE login
         ON ENDKEY UNDO login, LEAVE login: 
         RUN btb/btapi910za.p (INPUT INPUT FRAME frame01 ttwork.cod-usuario, 
                               INPUT INPUT FRAME frame01 vCod-Senha, 
                               OUTPUT TABLE tt-erros) NO-ERROR.
      END.
       
      IF CAN-FIND (FIRST tt-erros WHERE tt-erros.cod-erro = 4753) THEN DO:
         {bcp/bc9105.i "4753" "Usu†rio n∆o encontrado! (DC)"}
         ASSIGN vLogErro           = YES
                v_cod_usuar_corren = ''.
         RETURN ERROR.
      END.
      ELSE DO:
         IF CAN-FIND (FIRST tt-erros WHERE tt-erros.cod-erro = 4758) THEN DO:
            {bcp/bc9105.i "4758" "Senha para o usu†rio n∆o est†ˇcorreta! (DC)"} 
            ASSIGN vLogErro           = YES
                   v_cod_usuar_corren = ''.
            RETURN ERROR.
         END.
      END.
      IF NOT VALID-HANDLE(wgbcapiwms) THEN
         RUN bcp/bcapiwms.p PERSISTENT SET wgbcapiwms NO-ERROR.

      RUN piValidaUsuario IN wgbcapiwms (INPUT INPUT FRAME frame01 ttwork.cod-usuario,
                                         OUTPUT ttWork.cod-usuario).
                                          
      IF VALID-HANDLE(wgbcapiwms) THEN
         DELETE PROCEDURE wgbcapiwms NO-ERROR. 
                                           
      ASSIGN vLogControlaLogin = YES.
   END.

   IF NOT VALID-HANDLE(wgbosc079) THEN DO:
      RUN scbo/bosc079.p PERSISTENT SET wgbosc079.
      RUN openQueryStatic IN wgbosc079 (INPUT 'Main':U) NO-ERROR.
   END.

   RUN validaUsuario IN wgbosc079 (INPUT INPUT FRAME frame01 ttWork.cod-usuario,
                                   OUTPUT vLogUtilizaColetor,
                                   OUTPUT vLogAprovaFatura).
   IF RETURN-VALUE <> 'OK':U THEN DO:
      RUN getRowErrors IN wgbosc079 (OUTPUT TABLE RowErrors).
      IF vLogControlaLogin = YES THEN
         ASSIGN v_cod_usuar_corren  = ''
                v2_cod_usuar_corren = ''.
      FOR EACH RowErrors:
         ASSIGN ErrorDescription = ErrorDescription + "(WMS)":U.
         {bcp/bc9015.i2 STRING(ErrorNumber) STRING(ErrorDescription)}
      END.                                           
      ASSIGN vLogErro = YES.
   END.

   IF VALID-HANDLE(wgbosc079) THEN
      RUN destroy IN wgbosc079.

   IF vLogUtilizaColetor = NO THEN DO:
      ASSIGN vLogErro = YES.
      IF vLogControlaLogin = YES THEN
         ASSIGN v_cod_usuar_corren  = ''
               v2_cod_usuar_corren = ''.
      {bcp/bc9105.i "202" "Usu†rio sem permiss∆o para coletor (WMS)"}
   END.
   IF vLogErro = YES THEN
      RETURN ERROR.

   IF ttWork.cod-coletor = ''  THEN DO:
      ASSIGN vLogErro = YES.
      {bcp/bc9105.i "102" "Coletor Inv†lido (DC)"}
   END.
   IF ttWork.cod-equipamento = '' THEN DO:
      ASSIGN vLogErro = YES.
      {bcp/bc9105.i "103" "Equipamento Inv†lido (DC)"}
   END.
   IF vLogErro = YES THEN
      RETURN ERROR.

   /* instancia as BOs de forma PERSISTENTe */
   IF NOT VALID-HANDLE(wgbosc092) THEN DO:
      RUN scbo/bosc092.p PERSISTENT SET wgbosc092.
   END.
   /* valida se equipamento Ç DO tipo coletor */
   RUN validaEquipColetor IN wgbosc092 (INPUT  ttWork.cod-coletor,
                                        OUTPUT vCodTipoEquip,
                                        OUTPUT vLogAtivo,
                                        OUTPUT vLogProcesso).
   IF RETURN-VALUE <> 'OK':U THEN DO:
      ASSIGN vLogErro = YES.
      {bcp/bc9105.i "102" "Coletor Inv†lido (WMS)"}
      RETURN ERROR.
   END.

   /* valida se existe equipamento e se est† ativo */
   RUN validaEquipamento IN wgbosc092 (INPUT  ttWork.cod-equipamento,
                                       OUTPUT vLogAtivo,
                                       OUTPUT vLogProcesso).
   IF RETURN-VALUE <> 'OK':U THEN DO:
      ASSIGN vLogErro = YES.
      {bcp/bc9105.i "103" "Equipamento Inv†lido (WMS)"}
   END.
   IF vlogAtivo = NO THEN DO:
      ASSIGN vLogErro = YES.
      {bcp/bc9105.i "104" "Equipamento Desativado (WMS)"}
   END.

   IF VALID-HANDLE(wgbosc092) THEN
      RUN destroy IN wgbosc092.

   IF vLogErro = YES THEN 
      RETURN ERROR.

   RETURN "OK":U.

END PROCEDURE.

PROCEDURE GravaCamposFrame02:

   ASSIGN vLogErro     = NO
          vLogSai      = NO
          vLogFinaliza = NO
          vLogErro     = NO.

   FIND FIRST ttWork NO-ERROR.
   ASSIGN INPUT FRAME frame02 ttWork.cod-depos
          INPUT FRAME frame02 ttWork.cod-estabel
          INPUT FRAME frame02 ttWork.cod-local.

   IF NOT VALID-HANDLE(h-bosc070) THEN DO:
      RUN scbo/bosc070.p PERSISTENT SET h-bosc070.
   END.

   IF NOT VALID-HANDLE(h-bosc047) THEN DO:
      RUN scbo/bosc047.p PERSISTENT SET h-bosc047.
   END.

   IF NOT VALID-HANDLE(h-boIN084) THEN DO:
      RUN inbo/boin084.p PERSISTENT SET h-boIN084.
   END.

   IF VALID-HANDLE(h-bosc047) THEN DO:
      RUN openQueryStatic IN h-bosc047 (INPUT 'Main':U).
      RUN goToKey IN h-bosc047 (INPUT ttWork.cod-estabel,
                                INPUT ttWork.cod-local).
      IF RETURN-VALUE = 'NOK':U THEN DO:
         {bcp/bc9105.i "56" "Local Inv†lido (WMS)"}
         ASSIGN vLogErro = YES.
      END.
   END.

   IF VALID-HANDLE(h-boIN084) THEN DO:
      RUN openQueryStatic IN h-boIN084 (INPUT 'Main':U).
      RUN goToKey IN h-boIN084 (INPUT ttWork.cod-depos).

      IF RETURN-VALUE = 'NOK':U THEN DO:
         {bcp/bc9105.i "56" "Dep¢sito Inv†lido (WMS)"}
         ASSIGN vLogErro = YES.
      END.
   END.

   IF VALID-HANDLE(h-boIN084) THEN
      RUN destroy IN h-boIN084.
      
   IF VALID-HANDLE(h-bosc047) THEN
      RUN destroy IN h-bosc047.
      
   IF VALID-HANDLE(h-bosc070) THEN
      RUN destroy IN h-bosc070.

   IF vLogErro = YES THEN 
      RETURN ERROR.

   RETURN 'OK':U.

END PROCEDURE.

PROCEDURE InicializaCamposFrame03:

   FIND FIRST ttWork NO-ERROR.

   ASSIGN  ttWork.num-documento = 0
           ttWork.num-documento:SCREEN-VALUE IN FRAME Frame03 = '0'.

   RETURN 'OK':U.

END PROCEDURE.

PROCEDURE GravaCamposFrame03:

   ASSIGN vLogErro     = NO
          vLogSai      = NO
          vLogFinaliza = NO
          vLogErro     = NO.

   FIND FIRST ttWork NO-ERROR.
   ASSIGN INPUT FRAME frame03 ttWork.num-documento.

   IF ttWork.num-documento = 888888 THEN DO:
      RUN bcp/bc9046z.p (INPUT-OUTPUT TABLE ttWork).
      FIND FIRST ttWork NO-ERROR.
      IF ttWork.num-documento = 0 THEN DO:
         {bcp/bc9105.i "56" "Documento n∆o selecionado. (WMS)"}
         ASSIGN vLogErro = YES.
         RETURN ERROR.
      END.
      ELSE
         DISP ttWork.num-documento
            WITH FRAME {&Frame03Name}.
   END.

   IF NOT VALID-HANDLE(h-bosc070) THEN DO:
      RUN scbo/bosc070.p PERSISTENT SET h-bosc070.
   END.

   IF VALID-HANDLE(h-bosc070) THEN DO:
      RUN openQueryStatic IN h-bosc070 (INPUT 'Main':U).
      RUN goToKey         IN h-bosc070 (INPUT ttWork.num-documento).
      IF RETURN-VALUE = 'NOK':U THEN DO:
         {bcp/bc9105.i "56" "Documento de Transferància Inv†lido (WMS)"}
         ASSIGN vLogErro = YES.
         RETURN ERROR.
      END.
      ELSE DO:
         RUN getRecord IN h-bosc070 (OUTPUT TABLE tt-docto-transf-depos).
         FIND FIRST tt-docto-transf-depos NO-ERROR.
         IF AVAIL tt-docto-transf-depos THEN DO:
            IF tt-docto-transf-depos.cod-estab <> ttWork.cod-estabel THEN DO:
               {bcp/bc9105.i "402" "Estabelecimento Diferente (WMS)"}
               ASSIGN vLogErro = YES.
               RETURN ERROR.
            END.

            IF NOT VALID-HANDLE(h-bosc047) THEN DO:
               RUN scbo/bosc047.p PERSISTENT SET h-bosc047.
            END.
            RUN getRecord IN h-bosc047 (OUTPUT TABLE tt-local).
            IF VALID-HANDLE(h-bosc047) THEN
               RUN destroy IN h-bosc047.

            FIND FIRST tt-local NO-ERROR.
            IF (AVAIL tt-local                                              
                  AND tt-local.cod-deposito <> tt-docto-transf-depos.cod-depos-saida)
                   OR ttWork.cod-depos   <> tt-docto-transf-depos.cod-depos-entr  THEN DO:
               {bcp/bc9105.i "402" "Dep¢sito Diferente (WMS)"}
               ASSIGN vLogErro = YES.
               RETURN ERROR.
            END.
            IF tt-docto-transf-depos.idi-sit-docto <> 3 THEN DO:
               {bcp/bc9105.i "402" "N∆o existem itens para confirmaá∆o. (WMS)"}
               ASSIGN vLogErro = YES.
               RETURN ERROR.
            END.
            FIND FIRST wm-docto NO-LOCK
                 WHERE wm-docto.id-docto = tt-docto-transf-depos.id-docto NO-ERROR.
            IF NOT AVAIL wm-docto THEN DO:
               {bcp/bc9105.i "402" "Documento WMS n∆o encontrado. (WMS)"}
               ASSIGN vLogErro = YES.
               RETURN ERROR.
            END.
            ELSE DO:
               IF NOT CAN-FIND(FIRST wm-box-movto NO-LOCK
                               WHERE wm-box-movto.cod-estabel = wm-docto.cod-estabel
                                 AND wm-box-movto.cod-local   = wm-docto.cod-local
                                 AND wm-box-movto.id-docto    = wm-docto.id-docto
                                 AND wm-box-movto.qtd-item * wm-box-movto.qti-embalagem > qtd-liber-erp) THEN DO:
                  {bcp/bc9105.i "402" "N∆o existe qtd pendente para liberaá∆o. (WMS)"}
                  ASSIGN vLogErro = YES.
                  RETURN ERROR.
               END.
            END.
            IF NOT vLogErro THEN
               ASSIGN ttWork.id-docto = tt-docto-transf-depos.id-docto.
         END.
      END.
   END.

   IF VALID-HANDLE(h-bosc070) THEN
      RUN destroy IN h-bosc070.

   IF vLogErro THEN 
      RETURN ERROR.
   ELSE DO:
         RUN bcp/bc9046b.p (INPUT-OUTPUT TABLE ttWork).
   END.

   RETURN 'OK':U.

END PROCEDURE.

FINALLY:
   IF NOT lMenu AND THIS-PROCEDURE:PERSISTENT THEN
      DELETE PROCEDURE THIS-PROCEDURE.
  
   RETURN 'OK':U.
END FINALLY.
