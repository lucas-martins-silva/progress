/*:T*******************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC9043 2.00.00.012 } /*** "010012" 09/10/2025 11:26:33 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i BC9043 MBC}
&ENDIF

{include/i_dbvers.i}  /* versao das bases e bases instaladas */

/* Definicao global do nome da transacao ---                */
&global-define ProgramName BC9043
&global-define TempTable tt-separa-packing
{bcp/bc9043.i " "}
{utp/utapi009.i} /* login */
{utp/ut-glob.i}                
{method/dbotterr.i}
{bcp/bc9015.i3}  /* def variaveis padroes */
{bcp/bc9048.i1} /* definicao variaveis menu padrao */

DEFINE VARIABLE l-menu-padrao AS LOGICAL INITIAL YES NO-UNDO.

DEFINE TEMP-TABLE ttWork NO-UNDO
    FIELD cod-usuario      AS CHARACTER FORMAT 'x(25)':U            LABEL 'Usuario'         
    FIELD cod-coletor      AS CHARACTER FORMAT 'x(14)':U            LABEL 'Coletor'      INITIAL ""
    FIELD cod-equipamento  AS CHARACTER FORMAT 'x(14)':U            LABEL 'Equipamento'  INITIAL ""
    FIELD cod-estabel      AS CHARACTER FORMAT 'x(5)':U             LABEL 'Estabelecimento'
    FIELD cod-local        AS CHARACTER FORMAT 'x(3)':U             LABEL 'Local'
    FIELD cdd-embarq       AS DECIMAL   FORMAT '>>>>>>>>>>>>>>>9':U LABEL 'Nr.Embarque'.
CREATE ttWork.

DEFINE TEMP-TABLE ttpedidos NO-UNDO
    FIELD embarque   LIKE wms-box-packing.cdd-embarq
    FIELD resumo     LIKE wms-box-packing.nr-resumo
    FIELD pedido     LIKE wms-box-packing.nr-pedcli
    FIELD nome-abrev LIKE wms-box-packing.nome-abrev.

DEFINE TEMP-TABLE ttbox-armazenados NO-UNDO
    FIELD cod-estabel            LIKE wms-box-packing.cod-estabel  
    FIELD cod-local              LIKE wms-box-packing.cod-local
    FIELD cdd-embarq             LIKE wms-box-packing.cdd-embarq
    FIELD nr-resumo              LIKE wms-box-packing.nr-resumo
    FIELD nr-pedcli              LIKE wms-box-packing.nr-pedcli
    FIELD nome-abrev             LIKE wms-box-packing.nome-abrev
    FIELD id-box                 LIKE wms-box-packing.id-box
    FIELD bloco                  LIKE wms-box-espera.cod-bloco
    FIELD rua                    LIKE wms-box-espera.cod-rua
    FIELD nivel                  LIKE wms-box-espera.cod-nivel
    FIELD coluna                 LIKE wms-box-espera.cod-coluna
    FIELD lado                   LIKE wms-box-espera.ind-posicao-box
    FIELD total-vol-box          AS INTEGER
    FIELD total-vol-separado-box AS INTEGER.

DEFINE TEMP-TABLE ttwms-box-espera NO-UNDO LIKE wms-box-espera
    FIELD r-Rowid AS ROWID.

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
DEFINE VARIABLE i-conta-pedidos        AS INTEGER                     NO-UNDO.
DEFINE VARIABLE p-embarq               AS DECIMAL                     NO-UNDO.
DEFINE VARIABLE p-resumo               AS INTEGER                     NO-UNDO.
DEFINE VARIABLE p-pedido               AS CHARACTER                   NO-UNDO.
DEFINE VARIABLE p-nome-abrev           AS CHARACTER                   NO-UNDO.
DEFINE VARIABLE i-qtd-vol-total        AS INTEGER                     NO-UNDO.
DEFINE VARIABLE i-qtd-vol-separado     AS INTEGER                     NO-UNDO.
DEFINE VARIABLE p-id-box               AS DECIMAL FORMAT '>>>>>>>>>9':U NO-UNDO.  
DEFINE VARIABLE p-retornou-esc         AS LOGICAL     NO-UNDO.
DEFINE VARIABLE vNumCont                AS INTEGER   INITIAL 0        NO-UNDO.

DEFINE VARIABLE wgbosc079          AS HANDLE                       NO-UNDO.
DEFINE VARIABLE wgbosc092          AS HANDLE                       NO-UNDO.
DEFINE VARIABLE wgbosc135          AS HANDLE                       NO-UNDO.
DEFINE VARIABLE wgbosc047          AS HANDLE                       NO-UNDO.
DEFINE VARIABLE wgbosc109          AS HANDLE                       NO-UNDO.
DEFINE VARIABLE wgbosc169          AS HANDLE                       NO-UNDO.
DEFINE VARIABLE wgbosc168          AS HANDLE                       NO-UNDO.
DEFINE VARIABLE wgbcapiwms         AS HANDLE                       NO-UNDO. 

&global-define ActiveObject1 wgbosc079
&global-define ActiveObject2 wgbosc092
&global-define ActiveObject3 wgbosc047
&global-define ActiveObject4 wgbosc109
&global-define ActiveObject5 wgbosc169
&GLOBAL-DEFINE ActiveObject6 wgbosc135
&global-define ActiveObject7 wgbosc168
&global-define ActiveObject8 wgbcapiwms

&global-define ErrorDisplaySeconds 3
&global-define FrameSize    20 By 8 

/***************************************** Frames Inicio ******************************************/
/* Definicao da Frame01 ---                                 */
&global-define Frame01Name   Frame01
&global-define Frame01Defs   'Separaá∆o Packing   '                             At Row 01 Col 01          ~
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
&global-define Frame02Defs   'Separaá∆o Packing   '                             At Row 01 Col 01          ~
                             '--------------------'                             At Row 02 Col 01          ~
                             'Estab:'                                           AT ROW 03 COL 01          ~
                             ttWork.cod-estabel                                 AT ROW 03 COL 07 NO-LABEL ~
                             'Local:'                                           AT ROW 04 COL 01          ~
                             ttWork.cod-local                                   AT ROW 04 COL 07 NO-LABEL ~
                             'Embarque:'                                        At Row 05 Col 01          ~
                              ttWork.cdd-embarq                                 At Row 06 Col 02 NO-LABEL
&global-define Frame02Repeat YES

/* Definicao dos campos a serem recebidos ---               */
&global-define Update01Fields ttWork.cod-usuario WHEN ttWork.cod-usuario = '' ~
                              vCodSenha          WHEN ttWork.cod-usuario = '' ~
                              ttWork.cod-coletor ~
                              ttWork.cod-equipamento
&global-define Update02Fields ttWork.cod-estabel ~
                              ttWork.cod-local   ~
                              ttWork.cdd-embarq

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
                            ON 'enter':U OF ttWork.cod-estabel IN Frame Frame02             ~
                            DO:                                                             ~
                                APPLY 'entry':U TO ttWork.cod-local IN FRAME Frame02.       ~
                                RETURN NO-APPLY.                                            ~
                            END.                                                            ~
                            ON 'enter':U OF ttWork.cod-local IN Frame Frame02               ~
                            DO:                                                             ~
                                APPLY 'entry':U TO ttWork.cdd-embarq IN FRAME Frame02.      ~
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
         RUN btb/btapi910za.p (INPUT  ttWork.cod-usuario:SCREEN-VALUE IN FRAME {&Frame01Name}, 
                               INPUT  vCodSenha,
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
   
   IF NOT VALID-HANDLE(wgbosc135) THEN DO:
      RUN scbo/bosc135.p PERSISTENT SET wgbosc135 NO-ERROR.
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

   /*valida tarefa usuario*/
   RUN  validaUsuarioTarefa IN wgbosc135 (INPUT ttWork.cod-usuario,
                                          INPUT 19). /*Tarefa Separaá∆o Packing Espera*/
   IF RETURN-VALUE <> 'OK':U THEN DO:
      RUN getrowErrors IN wgbosc135 (OUTPUT TABLE RowErrors).
      FOR EACH RowErrors:
         ASSIGN ErrorDescription = ErrorDescription + "(WMS)":U.
         {bcp/bc9015.i2 STRING(ErrorNumber) STRING(ErrorDescription)}
      END.
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
   RUN validaEquipTransportador In wgbosc092 (INPUT  ttWork.cod-equipamento,
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
   
   IF VALID-HANDLE(wgbosc135) THEN
      DELETE PROCEDURE wgbosc135.

END PROCEDURE.

PROCEDURE InicializaCamposFrame02:   
   ASSIGN vLogErro  = NO.
   
   IF NOT VALID-HANDLE(wgbosc047) THEN DO:
      RUN scbo/bosc047.p PERSISTENT SET wgbosc047.
      RUN openQueryStatic IN wgbosc047 (INPUT "Main":U) NO-ERROR.
   END.

   IF NOT VALID-HANDLE(wgbosc109) THEN DO:
      RUN scbo/bosc109.p PERSISTENT SET wgbosc109.
      RUN openQueryStatic IN wgbosc109 (INPUT "Main":U) NO-ERROR.
   END.

   IF NOT VALID-HANDLE(wgbosc169) THEN DO:
      RUN scbo/bosc169.p PERSISTENT SET wgbosc169.
      RUN openQueryStatic IN wgbosc169 (INPUT "Main":U) NO-ERROR.
   END.

   IF NOT VALID-HANDLE(wgbosc168)  THEN DO:
      RUN scbo/bosc168.p PERSISTENT SET wgbosc168.
      RUN openQueryStatic IN wgbosc168 (INPUT "Main":U) NO-ERROR. 
   END.              
    
   RUN getEstabelLocalPad IN wgbosc047 (OUTPUT ttWork.cod-estabel,
                                        OUTPUT ttWork.cod-local).

   ASSIGN ttWork.cdd-embarq = 0.

   DISP ttWork.cod-estabel
        ttWork.cod-local
        ttWork.cdd-embarq
      WITH FRAME Frame02.
    
   APPLY 'leave':U TO ttWork.cod-estabel IN FRAME Frame02. 

END PROCEDURE.

PROCEDURE GravaCamposFrame02:
   ASSIGN  vLogErro = NO.
   ASSIGN INPUT FRAME  Frame02 ttWork.cod-estabel
                               ttWork.cod-local
                               ttWork.cdd-embarq.

   /*Valida Estabelecimento e Local*/
   RUN Gotokey IN wgbosc047 (INPUT ttWork.cod-estabel,
                             INPUT ttWork.cod-local).
   IF RETURN-VALUE <> 'OK':U THEN DO:
      ASSIGN vLogErro = YES.
      {bcp/bc9105.i "201" "Estab/Local Inv†lido. (WMS)"}
      RETURN ERROR.
   END.
    
   /*Valida Embarque*/
   RUN verifyEmbarqueEstabel IN wgbosc109 (INPUT ttWork.cod-estabel,
                                           INPUT ttWork.cod-local,
                                           INPUT ttWork.cdd-embarq).
   IF RETURN-VALUE <> 'OK':U THEN DO:
      ASSIGN vLogErro = YES.
      {bcp/bc9105.i "202" "Embarque Inexistente.(WMS)"}
      RETURN ERROR.     
   END.

   /*Carrega Pedidos do Embarque*/
   EMPTY TEMP-TABLE ttpedidos. 
   RUN retornaPedidos IN wgbosc169 (INPUT ttWork.cod-estabel,
                                    INPUT ttWork.cod-local,
                                    INPUT ttWork.cdd-embarq,
                                    OUTPUT TABLE ttpedidos).
   IF RETURN-VALUE <> 'OK':U THEN DO:
      RUN getrowErrors IN wgbosc169 (OUTPUT TABLE RowErrors).
      ASSIGN vLogErro = YES.

      FOR EACH RowErrors:
         ASSIGN ErrorDescription = ErrorDescription + "(WMS)":U.
         {bcp/bc9015.i2 STRING(ErrorNumber) STRING(ErrorDescription)}
      END.
      RETURN ERROR.
   END.
    
   ASSIGN i-conta-pedidos = 0
          p-embarq        = 0
          p-resumo        = 0
          p-pedido        = ""
          p-nome-abrev    = "".

   FOR EACH ttpedidos:
      ASSIGN i-conta-pedidos = i-conta-pedidos + 1
             p-embarq        = ttpedidos.embarque  
             p-resumo        = ttpedidos.resumo    
             p-pedido        = ttpedidos.pedido    
             p-nome-abrev    = ttpedidos.nome-abrev.
   END.

   IF i-conta-pedidos > 1 THEN DO:
      HIDE ALL NO-PAUSE.
      RUN bcp/bc9043a.p (INPUT TABLE ttpedidos,
                         OUTPUT p-embarq,
                         OUTPUT p-resumo,
                         OUTPUT p-pedido,
                         OUTPUT p-nome-abrev).
      HIDE ALL NO-PAUSE.
      IF p-pedido = "" THEN DO:
         ASSIGN vLogErro = YES.
         {bcp/bc9105.i "202" "Nenhum pedido foi selecionado.(WMS)"}
         RETURN ERROR.     
      END.                      
   END.

   /* Limpa a tempor·ria de erros */
   RUN emptyRowErrors IN wgbosc169.

   RUN validaSeparacaoPendente IN wgbosc169 (INPUT ttWork.cod-estabel,
                                             INPUT ttWork.cod-local,
                                             INPUT p-embarq,
                                             INPUT p-resumo,
                                             INPUT p-pedido,
                                             INPUT p-nome-abrev).
   IF RETURN-VALUE <> 'OK':U THEN DO:
      RUN getrowErrors IN wgbosc169 (OUTPUT TABLE RowErrors).
      ASSIGN vLogErro = YES.
      FOR EACH RowErrors:
         ASSIGN ErrorDescription = ErrorDescription + "(WMS)":U.
         {bcp/bc9015.i2 STRING(ErrorNumber) STRING(ErrorDescription)}
      END.
      RETURN ERROR.
   END.

   ASSIGN i-qtd-vol-total        = 0
          i-qtd-vol-separado     = 0.
    
   EMPTY TEMP-TABLE ttbox-armazenados.
    
   RUN retornaVolumesArmazenados IN wgbosc169(INPUT ttWork.cod-estabel,
                                              INPUT ttWork.cod-local,
                                              INPUT p-embarq,
                                              INPUT p-resumo,
                                              INPUT p-pedido,
                                              INPUT p-nome-abrev,
                                              OUTPUT TABLE ttbox-armazenados,
                                              OUTPUT i-qtd-vol-total,
                                              OUTPUT i-qtd-vol-separado).

   DO WHILE i-qtd-vol-total > i-qtd-vol-separado:
      HIDE ALL NO-PAUSE.
      RUN bcp/bc9043b.p (INPUT p-embarq,
                         INPUT p-resumo,
                         INPUT p-pedido,
                         INPUT p-nome-abrev,
                         INPUT TABLE ttbox-armazenados,
                         INPUT i-qtd-vol-total,
                         INPUT i-qtd-vol-separado,
                         OUTPUT p-id-box,
                         OUTPUT p-retornou-esc).
      HIDE ALL NO-PAUSE.
      IF p-retornou-esc THEN DO:
         LEAVE.
      END.      

      RUN setConstraintEstabelLocalIdBox2 IN wgbosc168 (INPUT ttWork.cod-estabel,                            
                                                        INPUT ttWork.cod-local,                              
                                                        INPUT p-id-box,                                  
                                                        INPUT p-id-box).
                                                                                          
      RUN openQueryStatic IN wgbosc168 (INPUT 'EstabelLocalIdBox2':U).                                 
      RUN getBatchRecords IN wgbosc168 (INPUT  ?,                                                      
                                        INPUT  NO,                                                     
                                        INPUT  ?,                                                      
                                        OUTPUT vNumCont,                                               
                                        OUTPUT TABLE ttwms-box-espera).                                
      FIND FIRST ttwms-box-espera NO-ERROR.                                                                
      IF AVAIL ttwms-box-espera THEN DO:                                                                   
         IF ttwms-box-espera.log-bloq-retir = YES THEN DO:                                               
            {bcp/bc9105.i "203" "Endereáo Bloqueado para Retirada. (WMS)"}
         END.
         ELSE DO:
            HIDE ALL NO-PAUSE.
            RUN bcp/bc9043c.p (INPUT ttWork.cod-usuario,
                               INPUT ttWork.cod-coletor, 
                               INPUT ttWork.cod-equipamento,
                               INPUT p-embarq,
                               INPUT p-resumo,
                               INPUT p-pedido,
                               INPUT p-nome-abrev,
                               INPUT p-id-box,
                               INPUT TABLE ttbox-armazenados).
            HIDE ALL NO-PAUSE.       
         END.
      END.

      EMPTY TEMP-TABLE ttbox-armazenados. 
      RUN retornaVolumesArmazenados IN wgbosc169(INPUT ttWork.cod-estabel,
                                                 INPUT ttWork.cod-local,
                                                 INPUT p-embarq,
                                                 INPUT p-resumo,
                                                 INPUT p-pedido,
                                                 INPUT p-nome-abrev,
                                                 OUTPUT TABLE ttbox-armazenados,
                                                 OUTPUT i-qtd-vol-total,
                                                 OUTPUT i-qtd-vol-separado).
   END.
END PROCEDURE.

FINALLY:
   IF NOT lMenu AND THIS-PROCEDURE:PERSISTENT THEN
      DELETE PROCEDURE THIS-PROCEDURE.
  
   RETURN 'OK':U.
END FINALLY.
