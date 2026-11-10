/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i MLAAPI173F 2.00.01.000 } /*** 010100 ***/


&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i mlaapi173f MML}
&ENDIF

/*******************************************************************************
**
**   Programa..:  MLAAPI173f.P
**   Data......:  Dezembro de 2004.
**   Objetivo .:  Verifica se existe aprovadores para o documento, tipos de docu-
**                mentos, retornando para ser realizado a valida‡Æo.
**                
**   Parƒmetros passados para MLAAPI173f:
**
**      I-tipo (Integer)           - Tipo de documento recebido (depois convertidos para os c¢digos do MLA)
**      c-it-codigo (char)         - C¢digo do Item
**      c-usuario   (char)         - Usu rio reponsavel pelo documento 
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
**      Programas que chamam a MLAAPI173f: afp/af0124.p
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
   DEF INPUT  PARAMETER i-empresa          LIKE empresa.ep-codigo     NO-UNDO.
   DEF OUTPUT PARAM TABLE FOR tt-erro-aed.

   {lap/mlaapi173.i2}
