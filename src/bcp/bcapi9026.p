/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BCAPI9026 2.00.00.018 } /*** "010018" 01/02/2026 20:44:33 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i bcapi9026 MBC}
&ENDIF


{include/i_dbinst.i}
/*------------------------------------------------------------------------ */
/*     File: bcapiwms.p                                                    */
/*     Purpose: Api with standart procedures for WMS                       */
/*------------------------------------------------------------------------ */


/* ***************************  Main Block  *************************** */
{bcp/bc9102.i}

DEFINE TEMP-TABLE tt-etiqueta-wms NO-UNDO
            FIELD id-etiqueta   LIKE wm-etiqueta.id-etiqueta
            FIELD cod-embalagem LIKE wm-embalagem.cod-embalagem
            FIELD cod-layout    AS INTEGER. /* C¢digo da etiqueta de layout */

DEFINE INPUT PARAMETER TABLE FOR tt-etiqueta-wms.
DEFINE OUTPUT PARAMETER TABLE FOR tt-erro.

/* ***************************   Includes   *************************** */
{method/dbotterr.i}

{utp/ut-glob.i}
{bcp/bcapi004.i}
{bcp/bcapi002.i}                 /* Definicao da temp-table tt-etiqueta   */
{bcp/bcapi001.i}                 /* Definicao da temp-table tt-trans      */

DEF TEMP-TABLE ttwm-Etiqueta NO-UNDO LIKE wm-etiqueta. /* Definiá∆o da temp-table ttwm-etiqueta */

/* ***************************  Definitions  ************************** */

DEFINE VARIABLE hBosc148       AS HANDLE                     NO-UNDO.
DEFINE VARIABLE Hbosc044       AS HANDLE                     NO-UNDO.
DEFINE VARIABLE Hbosc074       AS HANDLE                     NO-UNDO.
DEFINE VARIABLE i-cont         AS INTEGER                    NO-UNDO.
DEFINE VARIABLE vTransDetail   AS CHARACTER                  NO-UNDO.
DEFINE VARIABLE vRaw           AS RAW                        NO-UNDO.
DEFINE VARIABLE cFieldname     AS CHARACTER                  NO-UNDO.
DEFINE VARIABLE cCodLayout     AS CHARACTER                  NO-UNDO.
DEFINE VARIABLE cCodEan        AS CHARACTER                  NO-UNDO.
DEFINE VARIABLE cCodDun        AS CHARACTER                  NO-UNDO.
DEFINE VARIABLE cdTrans        AS CHARACTER                  NO-UNDO.
DEFINE VARIABLE iQtd-item-etiq AS DECIMAL                    NO-UNDO.

DEFINE NEW GLOBAL SHARED VARIABLE gcod-programa AS CHARACTER NO-UNDO.

FOR EACH tt-etiqueta-wms NO-LOCK:
   FOR FIRST wm-etiqueta
       WHERE wm-etiqueta.id-etiqueta = tt-etiqueta-wms.id-etiqueta NO-LOCK:
      ASSIGN gcod-programa = wm-etiqueta.cod-prog-origem.
   END.
    
   FIND FIRST bc-etiqueta 
        WHERE bc-etiqueta.progressivo = string(tt-etiqueta-wms.id-etiqueta) EXCLUSIVE-LOCK NO-ERROR.
   IF NOT AVAIL bc-etiqueta THEN DO:
      IF AVAIL wm-etiqueta THEN DO:
         CREATE bc-etiqueta.
         ASSIGN bc-etiqueta.nr-ord-produ  = IF wm-etiqueta.nr-ord-prod = 999999999 THEN 0 ELSE wm-etiqueta.nr-ord-prod
                bc-etiqueta.nro-docto     = IF wm-etiqueta.nr-ord-prod = 999999999 THEN "0" ELSE STRING(wm-etiqueta.nr-ord-prod )
                bc-etiqueta.qt-item       = 0
                bc-etiqueta.usuar-criacao = c-seg-usuario
                bc-etiqueta.it-codigo     = wm-etiqueta.cod-item
                bc-etiqueta.lote          = wm-etiqueta.cod-lote  
                bc-etiqueta.referencia    = wm-etiqueta.cod-refer
                bc-etiqueta.dt-validade   = wm-etiqueta.dt-validade-lote 
                bc-etiqueta.cod-estabel   = wm-etiqueta.cod-estabel
                bc-etiqueta.progressivo   = STRING(wm-etiqueta.id-etiqueta). 
      END.
   END.

   IF NOT VALID-HANDLE (hBosc074) THEN
      RUN scbo/bosc074.p PERSISTENT SET hbosc074.
   
   RUN openQueryStatic IN hBosc074 (INPUT "Main":U).

   RUN getInfoEtiqueta IN Hbosc074 (INPUT tt-etiqueta-wms.id-etiqueta,
                                    OUTPUT TABLE ttwm-etiqueta).
   IF VALID-HANDLE (hBosc074) THEN
      DELETE OBJECT hBosc074.
	
   FIND FIRST ttwm-etiqueta NO-LOCK NO-ERROR.
   /* Busca valor do cod-layout executando BOs, dependendo da vers∆o do EMS */
	
   IF NOT VALID-HANDLE (hBosc148) THEN
      RUN scbo/bosc148.p PERSISTENT SET hbosc148.

   RUN openQueryStatic IN hBosc148 (INPUT "Main":U).

   /* Posiciona no documento */
   RUN goToKey IN hBosc148(INPUT ttwm-etiqueta.cod-item,
                           INPUT ttwm-etiqueta.cod-embalagem).

   RUN getCharField IN hBosc148 (INPUT "cod-layout",
                                 OUTPUT cCodLayout).

   RUN getCharField IN hBosc148 (INPUT "cod-barras",
                                 OUTPUT cCodDun).

   IF VALID-HANDLE (hBosc148) THEN
      DELETE OBJECT hBosc148.


   IF NOT VALID-HANDLE (hBosc044) THEN
      RUN scbo/bosc044.p PERSISTENT SET hbosc044.
   
   RUN openQueryStatic IN hBosc044 (INPUT "Main":U).

   /* Posiciona no documento */
   RUN goToKey IN hBosc044 (INPUT ttwm-etiqueta.cod-item).

   RUN getCharField IN hBosc044 (INPUT "cod-barras",
                                 OUTPUT cCodEAN).
   IF VALID-HANDLE (hBosc044) THEN
      DELETE OBJECT hBosc044.


   /* Buscar Informaá‰es da Etiqueta */
   EMPTY TEMP-TABLE tt-etiqueta.
   EMPTY TEMP-TABLE tt-trans.

   FIND FIRST item
        WHERE item.it-codigo = ttwm-etiqueta.cod-item NO-LOCK NO-ERROR.

   FIND FIRST wm-embalagem
        WHERE wm-embalagem.cod-embalagem = wm-etiqueta.cod-embalagem NO-LOCK NO-ERROR.
	
	ASSIGN iQtd-item-etiq = 0.	
	IF (ttwm-etiqueta.qtd-item - ttwm-etiqueta.qtd-item-retirado) <= 0 THEN
	   ASSIGN iQtd-item-etiq = ttwm-etiqueta.qtd-item.
	ELSE
       ASSIGN iQtd-item-etiq = ttwm-etiqueta.qtd-item - ttwm-etiqueta.qtd-item-retirado.
	   

   CREATE tt-etiqueta.
   ASSIGN tt-etiqueta.cod-versao-integracao = 1
          tt-etiqueta.i-sequen              = 1
          tt-etiqueta.qt-etiqueta           = 1
          tt-etiqueta.cd-trans              = "WMOut004":U
          tt-etiqueta.tipo-etiq             = INTEGER(cCodlayout)
          tt-etiqueta.desc-item             = IF AVAIL item THEN item.desc-item ELSE ''
          tt-etiqueta.desc-etiqueta         = IF AVAIL item THEN item.descricao-1 ELSE ''
          tt-etiqueta.nr-docto              = STRING(bc-etiqueta.nro-docto)
          tt-etiqueta.quantidade            = IF ttwm-etiqueta.ind-sit-agrupador = 2 AND  ttwm-etiqueta.qtd-item = 0 THEN 1 ELSE iQtd-item-etiq
          tt-etiqueta.usuario               = c-seg-usuario
          tt-etiqueta.it-codigo             = ttwm-etiqueta.cod-item
          tt-etiqueta.cod-referencia        = ttwm-etiqueta.cod-refer
          tt-etiqueta.lote                  = ttwm-etiqueta.cod-lote
          tt-etiqueta.cod-depos             = bc-etiqueta.cod-depos
          tt-etiqueta.cod-localiz           = bc-etiqueta.cod-local
          tt-etiqueta.dt-val-lote           = ttwm-etiqueta.dt-validade-lote
          tt-etiqueta.cod-estabel           = ttwm-etiqueta.cod-estabel
          tt-etiqueta.peso-liquido          = wm-etiqueta.qtd-peso
          tt-etiqueta.peso-bruto            = tt-etiqueta.peso-liquido + wm-embalagem.qtd-peso
          tt-etiqueta.auxiliar-01           = cCodEan 
          tt-etiqueta.auxiliar-02           = cCodDun  
          tt-etiqueta.auxiliar-03           = STRING(ttwm-etiqueta.id-etiqueta).     /* serial do wms */

   ASSIGN vTransDetail = "WMOut004" +
                         " WMS - Reimpressao de Etiqueta " +
                         " Etiqueta: " + STRING(tt-etiqueta-wms.id-etiqueta) +
                         " Usuario: " + STRING(c-seg-usuario) +
                         " Data: " + STRING(TODAY,'99/99/9999') +
                         " Hora: " + STRING(TIME,'hh:mm:ss').

   RAW-TRANSFER tt-etiqueta TO vRaw NO-ERROR.

   CREATE tt-trans.
   ASSIGN tt-trans.cod-versao-integracao  = 1
          tt-trans.i-sequen               = 1
          tt-trans.cd-trans               = "WMOut004"
          tt-trans.detalhe                = vTransDetail
          tt-trans.usuario                = c-seg-usuario
          tt-trans.conteudo-trans         = vRaw
          tt-trans.atualizada             = NO
          tt-trans.etiqueta               = YES.

   RUN bcp/bcapi001.p (INPUT-OUTPUT TABLE tt-trans,
                       INPUT-OUTPUT TABLE tt-erro).

   ASSIGN gcod-programa = "".

   FIND FIRST tt-erro NO-LOCK NO-ERROR .

   IF AVAIL tt-erro THEN
      RETURN "NOK":U.
END.
RETURN "OK":U.
