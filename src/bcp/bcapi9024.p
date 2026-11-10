/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BCAPI9024 2.00.00.017 } /*** "010017" 22/10/2024 16:45:21 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i bcapi9024 MBC}
&ENDIF


/********************************************************************************
** Copyright DATASUL S.A. (2003)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
/*****************************************************************************
**     Programa...: bcapi9024.p  
**
**     Finalidade.: Api de efetivacao de invent†rio WMS
**
**     Criado em..: novembro de 2002
**
**     Versao.....: 2.00.00.000
******************************************************************************/
{bcp/bc9102.i}     /* Definicao da temp-table de erros do coleta de dados    */
{bcp/bc9107.i}     /* Definicao dos campos de comunicacao com o adapter      */
{bcp/bcapi001.i}   /* Definicao da temp-table tt-trans                       */
{bcp/bcapi002.i}   /* Definicao da temp-table tt-etiqueta                    */
{bcp/bcapi004.i}   /* Definicao da temp-table tt-prog-bc                     */
{bcp/bc9024.i}     /* Include c definiá‰es da transaá∆o                      */

DEF VARIABLE i-cont-erro     AS INTEGER     NO-UNDO. 
DEF VARIABLE i-tip-leitura   AS INTEGER     NO-UNDO.     
DEF VARIABLE vusuario        AS CHARACTER   NO-UNDO.
DEF VARIABLE vdetalhe        AS CHARACTER   NO-UNDO.
DEF VARIABLE vnum-sequencia  AS INTEGER     NO-UNDO. 

/*****************************************************************************/

/*****************************************************************************/
DEFINE INPUT PARAMETER pNumTrans AS INTEGER NO-UNDO.
DEFINE INPUT PARAMETER TABLE FOR ttIntegracao.
DEFINE INPUT-OUTPUT PARAMETER TABLE FOR tt-erro.
/*****************************************************************************/
DEFINE TEMP-TABLE tt-leitura NO-UNDO
            FIELD CodItem        LIKE wm-inventario-item.cod-item
            FIELD CodRefer       LIKE wm-inventario-item.cod-refer
            FIELD CodLote        LIKE wm-inventario-item.cod-lote
            FIELD CodEmbalagem   LIKE wm-inventario-item.cod-embalagem
            FIELD IdEtiqueta     LIKE wm-inventario-etiqueta.id-etiqueta
            FIELD QtdApurada     LIKE wm-inventario-item.qtd-apurada[1]
            FIELD QtdPeso        LIKE wm-inventario-item.qtd-apurada-peso[1]           
            FIELD DtValiLote     LIKE wm-inventario-item.dt-vali-lote
            FIELD processado     AS LOGICAL INIT NO
            INDEX item     CodItem CodRefer CodLote IdEtiqueta
            INDEX etiqueta IdEtiqueta
            INDEX processado processado.

DEFINE TEMP-TABLE tt-bc-trans-leitura NO-UNDO 
            FIELD nr-trans       LIKE bc-trans-filho.nr-trans
            FIELD sequencia      LIKE bc-trans-filho.sequencia
            FIELD num-seq-invent LIKE wm-inventario.num-seq-invent
            FIELD id-box         LIKE wm-inventario-endereco.id-box
            FIELD coditem        LIKE wm-inventario-item.cod-item        
            FIELD codrefer       LIKE wm-inventario-item.cod-refer       
            FIELD codlote        LIKE wm-inventario-item.cod-lote        
            FIELD CodEmbalagem   LIKE wm-inventario-item.cod-embalagem
            FIELD idetiqueta     LIKE wm-inventario-etiqueta.id-etiqueta 
            FIELD qtdapurada     LIKE wm-inventario-item.qtd-apurada[1]
            FIELD QtdPeso        LIKE wm-inventario-item.qtd-apurada-peso[1]             
            FIELD dtvalilote     LIKE wm-inventario-item.dt-vali-lote
            FIELD log-existe-end AS LOGICAL FORMAT 'YES/NO':U .
  

/*****************************************************************************/
DEF BUFFER b-tt-bc-trans-leitura FOR tt-bc-trans-leitura.
/*****************************************************************************/
/* Inicializacao dos objetos ativos ---                     */ 
IF NOT VALID-HANDLE(wgbosc118) THEN DO:
   RUN scbo/bosc118.p PERSISTENT SET wgbosc118.
   RUN openQueryStatic IN wgbosc118 (INPUT "Main":U) NO-ERROR.
END.
/************************************************************/

BC9024:
DO TRANSACTION ON ERROR  UNDO BC9024, LEAVE BC9024
               ON QUIT   UNDO BC9024, LEAVE BC9024
               ON STOP   UNDO BC9024, LEAVE BC9024
               ON ENDKEY UNDO BC9024, LEAVE BC9024:

   CREATE tt-prog-bc.
   ASSIGN tt-prog-bc.cod-prog-dtsul        = "bc9024":U
          tt-prog-bc.cod-versao-integracao = 1
          tt-prog-bc.usuario               = c-seg-usuario
          tt-prog-bc.opcao                 = 1.

   RUN bcp/bcapi004.p ( INPUT-OUTPUT TABLE tt-prog-bc,
                        INPUT-OUTPUT TABLE tt-erro).

   FIND FIRST tt-prog-bc NO-ERROR.
   FIND FIRST tt-erro NO-ERROR.
   IF AVAIL tt-erro THEN DO:
      CREATE tt-erro.
      ASSIGN i-cont-erro = i-cont-erro + 1.
      /* Inicio -- Projeto Internacional */
      {utp/ut-liter.i "Erro_encontrado_quando_acessando_programa_bcapi004_(bc-prog-trans)" *}
      ASSIGN tt-erro.i-sequen    = i-cont-erro
             tt-erro.cd-erro     = 1
             tt-erro.mensagem    = RETURN-VALUE + '(DC)':U.
      RUN DeleteObjects.
      UNDO BC9024, RETURN 'NOK':U.
   END.

   ASSIGN vusuario = TRIM(_RetornaValChar('usuario':U)).
   ASSIGN vdetalhe = _RetornaValChar('detalhe':U).

   ASSIGN vLogOk = NO.
   {bcp/bc9017.i1  vusuario}
   IF vLogOk = NO THEN DO:
      CREATE tt-erro.
      ASSIGN i-cont-erro = i-cont-erro + 1.
      /* Inicio -- Projeto Internacional */
      DEFINE VARIABLE c-lbl-liter-usuario AS CHARACTER NO-UNDO.
      {utp/ut-liter.i "Usu†rio" *}
      ASSIGN c-lbl-liter-usuario = TRIM(RETURN-VALUE).
      DEFINE VARIABLE c-lbl-liter-nao-cadastrado-no-datasul-ems AS CHARACTER NO-UNDO.
      {utp/ut-liter.i "n∆o_cadastrado_no_Datasul-EMS" *}
      ASSIGN c-lbl-liter-nao-cadastrado-no-datasul-ems = TRIM(RETURN-VALUE).
      ASSIGN tt-erro.i-sequen    = i-cont-erro
             tt-erro.cd-erro     = 2
             tt-erro.mensagem    = c-lbl-liter-usuario + ' ' +  _RetornaValChar('usuario':U) + ' ' + c-lbl-liter-nao-cadastrado-no-datasul-ems + '(DC)':U.
      RUN DeleteObjects.
      UNDO BC9024, RETURN 'NOK':U.
   END.

   IF NOT CAN-FIND ( FIRST bc-trans-filho
                     WHERE bc-trans-filho.nr-trans = pNumTrans NO-LOCK) THEN DO:
      CREATE tt-erro.
      ASSIGN i-cont-erro = i-cont-erro + 1.
      /* Inicio -- Projeto Internacional */
      {utp/ut-liter.i "N∆o_foram_realizadas_leituras_de_invent†rio" *}
      ASSIGN tt-erro.i-sequen = i-cont-erro
             tt-erro.cd-erro  = 3
             tt-erro.mensagem = RETURN-VALUE + '.' + '(DC)':U.
      RUN DeleteObjects.
      UNDO BC9024, RETURN 'NOK':U.
   END.

   EMPTY TEMP-TABLE tt-bc-trans-leitura.
   
   FOR EACH bc-trans-filho FIELDS (bc-trans-filho.sequencia  bc-trans-filho.nr-trans bc-trans-filho.conteudo-trans)
      WHERE bc-trans-filho.nr-trans = pNumTrans NO-LOCK
         BY bc-trans-filho.sequencia:
      
      IF DECIMAL(ENTRY(2,ENTRY(4, bc-trans-filho.conteudo-trans,';':U),':':U)) = 999999 THEN
         NEXT. /* indica encerramento do inventario do box */
      
      CREATE tt-bc-trans-leitura.
      ASSIGN tt-bc-trans-leitura.sequencia       = bc-trans-filho.sequencia
             tt-bc-trans-leitura.num-seq-invent  = INTEGER(ENTRY(2,ENTRY(1,bc-trans-filho.conteudo-trans,';':U),':':U))
             tt-bc-trans-leitura.id-box          = INTEGER(ENTRY(2,ENTRY(2,bc-trans-filho.conteudo-trans,';':U),':':U))    
             tt-bc-trans-leitura.CodItem         = ENTRY(2,ENTRY(6, bc-trans-filho.conteudo-trans,';':U),':':U)  
             tt-bc-trans-leitura.CodRefer        = ENTRY(2,ENTRY(8, bc-trans-filho.conteudo-trans,';':U),':':U) 
             tt-bc-trans-leitura.CodLote         = ENTRY(2,ENTRY(7, bc-trans-filho.conteudo-trans,';':U),':':U)
             tt-bc-trans-leitura.CodEmbalagem    = ENTRY(2,ENTRY(9, bc-trans-filho.conteudo-trans,';':U),':':U)
             tt-bc-trans-leitura.IdEtiqueta      = DECIMAL(ENTRY(2,ENTRY(4, bc-trans-filho.conteudo-trans,';':U),':':U))
             tt-bc-trans-leitura.QtdApurada      = DECIMAL(ENTRY(2,ENTRY(5, bc-trans-filho.conteudo-trans,';':U),':':U))
             tt-bc-trans-leitura.QtdPeso         = DECIMAL(ENTRY(2,ENTRY(11, bc-trans-filho.conteudo-trans,';':U),':':U))              
             tt-bc-trans-leitura.DtValiLote      = DATE(ENTRY(2,ENTRY(10, bc-trans-filho.conteudo-trans,';':U),':':U)).
        
      IF ENTRY(2,ENTRY(3,bc-trans-filho.conteudo-trans,';':U),':':U) =  'YES':U THEN
         ASSIGN tt-bc-trans-leitura.log-existe-end = YES.
      
      IF ENTRY(2,ENTRY(3,bc-trans-filho.conteudo-trans,';':U),':':U) =  'NO':U THEN
         ASSIGN tt-bc-trans-leitura.log-existe-end = NO. 
   END.

   /* 17/05/06, Substitu°do por Solicitaá∆o Logistica */
   FOR EACH tt-bc-trans-leitura NO-LOCK
      BREAK BY tt-bc-trans-leitura.id-box:
        
      IF FIRST-OF (tt-bc-trans-leitura.id-box) THEN DO:
         EMPTY TEMP-TABLE tt-leitura.
         
         RUN emptyRowErrors IN wgbosc118.

         IF NOT tt-bc-trans-leitura.log-existe-end THEN DO: /* endereáo incluido durante invent†rio */
            RUN CreateEnderecoInventario IN wgbosc118(INPUT ENTRY(2,ENTRY(2,vdetalhe,';':U),':':U),        /* cod-estabelecimento */
                                                      INPUT ENTRY(2,ENTRY(3,vdetalhe,';':U),':':U),        /* cod-local */
                                                      INPUT DATE(ENTRY(2,ENTRY(4,vdetalhe,';':U),':':U)),  /* data invent†rio */
                                                      INPUT tt-bc-trans-leitura.num-seq-invent,            /* invent†rio */
                                                      INPUT tt-bc-trans-leitura.id-box).                   /* box       */
            IF RETURN-VALUE <> 'OK':U THEN DO:
               RUN getRowErrors IN wgbosc118 (OUTPUT TABLE RowErrors) NO-ERROR.
               ASSIGN vnum-sequencia = 0. 
               FOR EACH RowErrors:
                  ASSIGN vnum-sequencia = vnum-sequencia + 1.    
                  CREATE tt-erro.
                  ASSIGN tt-erro.i-sequen = vnum-sequencia
                         tt-erro.cd-erro  = ErrorNumber
                         tt-erro.mensagem = ErrorDescription + "(WMS)":U.
               END. 
               RUN deleteObjects.
               UNDO BC9024, RETURN 'NOK':U.
            END.
         END.
         /* Regra: quando box vazio, a tt-leitura n∆o deve ser populada */
         IF tt-bc-trans-leitura.IdEtiqueta <> 555555
            AND tt-bc-trans-leitura.IdEtiqueta <> 333333 THEN DO:
            FOR EACH b-tt-bc-trans-leitura
               WHERE b-tt-bc-trans-leitura.id-box  = tt-bc-trans-leitura.id-box:
               CREATE tt-leitura.
               BUFFER-COPY b-tt-bc-trans-leitura EXCEPT b-tt-bc-trans-leitura.sequencia TO tt-leitura.
            END.
         END.
         
         ASSIGN i-tip-leitura = 0. /* Contagem normal */
         IF tt-bc-trans-leitura.IdEtiqueta = 555555 THEN
            ASSIGN i-tip-leitura = 1. /* Endereáo vazio */

         RUN wmp/wm9100.p (INPUT ENTRY(2,ENTRY(2,vdetalhe,';':U),':':U),            /* cod-estabelecimento */
                           INPUT ENTRY(2,ENTRY(3,vdetalhe,';':U),':':U),            /* cod-local */
                           INPUT DATE(ENTRY(2,ENTRY(4,vdetalhe,';':U),':':U)),      /* data invent†rio */
                           INPUT tt-bc-trans-leitura.num-seq-invent,                /* sequencia invent†rio. ‘ igual p todos os bc-trans */
                           INPUT tt-bc-trans-leitura.id-box,                        /* box = endereáo */
                           INPUT ENTRY(2,ENTRY(1,vdetalhe,';':U),':':U),            /* usu†rio */
                           INPUT INTEGER(ENTRY(2,ENTRY(5,vdetalhe,';':U),':':U)),   /* numero da contagem */
                           INPUT i-tip-leitura,                                     /* indica tipo de leitura 0-Contagem normal, 1-Endereáo Vazio */
                           INPUT TABLE tt-leitura,
                           OUTPUT TABLE rowErrors).

         ASSIGN vnum-sequencia = 0. 
         FOR EACH RowErrors:
            ASSIGN vnum-sequencia = vnum-sequencia + 1.    
            CREATE tt-erro.
            ASSIGN tt-erro.i-sequen = vnum-sequencia
                   tt-erro.cd-erro  = ErrorNumber
                   tt-erro.mensagem = ErrorDescription + "(WMS)":U.
            RUN deleteObjects.
            UNDO BC9024, RETURN 'NOK':U.
         END.
      END.
   END.
   RUN deleteObjects.
   RETURN 'OK':U.
END.               

PROCEDURE deleteObjects:
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   RUN destroy IN wgbosc118 NO-ERROR.
   IF VALID-HANDLE(wgbosc118)THEN
      DELETE OBJECT wgbosc118.
   
   RUN destroy IN wgbosc120 NO-ERROR.
   IF VALID-HANDLE(wgbosc120) THEN
      DELETE OBJECT wgbosc120.

END PROCEDURE.
