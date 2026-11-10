/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i MLAAPI173 2.00.00.008 } /*** 010008 ***/


&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i mlaapi173 MML}
&ENDIF

/*******************************************************************************
**
**   Programa..:  MLAAPI173.P
**   Data......:  Dezembro de 2004.
**   Objetivo .:  Verifica se existe aprovadores para o documento, tipos de docu-
**                mentos, retornando para ser realizado a valida‡Æo.
**                
**   Cria‡Æo ..:  Cristiano de Souza
**
**   Parƒmetros passados para MLAAPI001:
**
**      I-tipo (Integer)           - Tipo de documento recebido (depois convertidos para os c¢digos do MLA)
**                                   1-Solicita‡Æo
**                                   2-Requisi‡Æo
**                                   3-Cota‡Æo
**                                   4-Pedido
**                                   5-Solicita‡Æo Cota‡Æo
**                                   6-Pedido Emergencial
**                                   7-Processo Compras
**                                   8-Contrato Fornec
**                                   11-Evento
**                                   12-Medi‡Æo
**      c-it-codigo (char)         - C¢digo do Item
**      c-usuario   (char)         - Usu rio reponsavel pelo documento 
**                                   (Comprador, gestor t‚cnico, responsavel pelo pedido,requisitante)
**      p-referencia-item  (char)  - referencia quando documento for parametrizado por item  - c¢digo da conta cont bil
**      p-referencia-total (char)  - referencia quando documento for parametrizado por total - c¢digo do estabelecimento
**      p-lotacao-doc (char)       - Lota‡Æo do usu rio responsavel pelo documento ou centro-custo
**                                   quando parametrizado pelo mesmo no usu rio do MLA
**      de-valor-item (dec)        - Valor do documento quando o mesmo for por item
**      de-valor-total (dec)       - Valor do documento quando o mesmo for por total
**      c-estabelecimento (char)   - Estabelecimento do documento
**
**      tt-erro-aed                    - temp table de erros 
**
**      Programas que chamam a MLAAPI173: 
**                                   ccp: cc0303a-v01.w;cc0303-b01.w;cc0303-b02.w;cc0311rp.p;ccapi300.p
**                                   cdp: cd1406a1-v01.w;cd1406a-v01.w
**                                   cnp: cn0201a-v01.w
**                                   inbo: boin082vl.p;boin168.p;boin168man.p;boin274vl.p;boin295.p;boin385.p;boin385man.p
**                                   invwr: v14in582.w;v15in112.w
**                                    
*****************************************************************************************************/

    define  temp-table tt-erro-aed no-undo
         field i-sequen as int             
         field cd-erro  as int
         field mensagem as char format "x(255)"
         field c-param  as char.

   DEF INPUT  PARAMETER i-tipo             AS INTEGER NO-UNDO.                                
   DEF INPUT  PARAMETER c-it-codigo        AS CHAR    NO-UNDO.                                
   DEF INPUT  PARAMETER c-usuario          AS CHAR    NO-UNDO.                                
   DEF INPUT  PARAMETER p-referencia-item  AS CHAR    NO-UNDO.                                
   DEF INPUT  PARAMETER p-referencia-total AS CHAR    NO-UNDO.                                
   DEF INPUT  PARAMETER p-lotacao-doc      AS CHAR    NO-UNDO.                                
   DEF INPUT  PARAMETER de-valor-item      AS DECIMAL NO-UNDO.                                
   DEF INPUT  PARAMETER de-valor-total     AS DECIMAL NO-UNDO.                                
   DEF INPUT  PARAMETER c-estabelecimento  LIKE estabelec.cod-estabel NO-UNDO.
   DEF OUTPUT PARAM TABLE FOR tt-erro-aed.

   DEF VAR i-empresa     LIKE empresa.ep-codigo NO-UNDO.

   FIND FIRST estabelec 
        WHERE estabelec.cod-estabel = c-estabelecimento NO-LOCK NO-ERROR.
   IF AVAIL estabelec then 
       run cdp/cd9970.p (input rowid(estabelec),
                         output i-empresa).

   {lap/mlaapi173.i2}
