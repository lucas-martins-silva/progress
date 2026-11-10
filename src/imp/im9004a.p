/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
** 
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IM9004A 2.00.00.056 } /*** "010056" 16/10/2026 09:59:10 ***/
 
&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i im9004a MIM}
&ENDIF
 
/*****************************************************************************
**
** IM9004A - Integraá∆o entre Importaá∆o e Recebimento (EMS)
**
** Objetivo: Duplicata da mercadoria - Importaá∆o.
**
******************************************************************************/
 
 
{cdp/cdcfgmat.i} /* include preprocessadores magnus */
{utp/ut-glob.i}
{cdp/cdcfgdis.i}
/* programa nao executado ambiente magnus */
&if defined(bf-mat-comex) &then
&else

def var i-empresa-prin        like param-global.empresa-prin.
 
{cdp/cd0666.i} /**** Definiá∆o da temp-table tt-erro ****/

{cdp/cd9700.i} /* variaveis ent futura / fat antecipado */
DEF BUFFER b-natur-oper-ent-fut   FOR natur-oper.
DEF BUFFER b-item-doc-est-ent-fut FOR item-doc-est.

{app/apapi004.i}

{mpp/mpapi006.i}

{app/apapi001b.i}
/***  Sempre que a apapi001.i for utilizada junto com a apapi201.i, a apapi001.i sempre dever† ser definida 
      primeiro e a vari†vel abaixo c-apapi001-inc dever† ser definida(com &scoped-define). Este procedimento
      Ç obrigat¢rio pois as includes definem temp-tables com os mesmos nomes, o que ocasionar† erro de 
      compilaá∆o caso este procedimento n∆o seja efetuado 
 ***/
&scoped-define c-apapi001-inc 

{cdp/cd4300.i3}             /*Vari†veis para o cd4300.i4 */

{include/i-epc200.i RE9340} /** Upc **/

/* procedure pi-busca-portador-modalidade */
{cdp/cd9900.i5}

define temp-table tt-previsao NO-UNDO
    field Ep-cod-pre      like tit-ap.ep-codigo
    field Cod-est-pre     like tit-ap.cod-estabel
    field Cod-esp-pre     like tit-ap.cod-esp
    field Serie-pre       like tit-ap.serie
    field nr-docto-pre    like tit-ap.nr-docto         
    field Parcela-pre     like tit-ap.parcela
    field Moeda-pre       like tit-ap.moeda
    field Cod-fornec      like tit-ap.cod-fornec
    field cotacao-dia     like tit-ap.cotacao-dia
    field Vl-previsao     like tit-ap.vl-original
    field Vl-previsao-me  like tit-ap.vl-orig-me
    FIELD baixa-tot       AS LOG INIT NO /* Indica se a baixa da previs∆o ser† total */
    FIELD vl-sdo-prev-me like tit-ap.vl-orig-me /* Saldo da previs∆o no financeiro */
    index CODIGO is primary ep-cod-pre
                            cod-est-pre
                            cod-esp-pre
                            serie-pre
                            nr-docto-pre
                            parcela-pre
                            cod-fornec.
                            
/* Importaá∆o */
define temp-table tt-lin-i-ap-aux NO-UNDO like tt-lin-i-ap.                            

def input-output parameter table for tt-erro.  
def input-output parameter table for tt-tit-ap.
def input-output parameter table for tt-lin-i-ap.
def input-output parameter table for tt-previsao.
def input-output parameter table for tt-lin-conta-ap.
def input-output parameter table for tt-doc-i-ap.
def input-output parameter table for tt-impto-tit-pend-ap.
def input-output parameter table for tt-l-pre-ap.
def input        parameter rw-docum-est   as rowid.
def input        parameter l-rec-brasil   as logical no-undo. /** Usado no re9340.i3 **/
def input-output parameter l-erro-at      as logical no-undo.
def input-output parameter i-cont         as integer no-undo.
def input-output parameter de-val-tot     as decimal no-undo.
def input-output parameter l-usa-mp       as logical.
def input        parameter l-erro-ap      as logical no-undo.
def input        parameter c-ref-aux      like lin-i-ap.referencia no-undo.
def input        parameter l-ems50        as logical no-undo.

/* Utilizado pelo RE9340.i3 */
def buffer b-dupli-imp        for dupli-imp.
def buffer b-dupli-apagar     for dupli-apagar.
def buffer b-tt-impto         for tt-impto-tit-pend-ap.
 
def buffer b-dupli-apagar-cex for dupli-apagar-cex.

def var l-antecipa            as logical no-undo. 
def var h_re0994e1            as handle no-undo.
def var de-vl-baixa-prev      as decimal no-undo.
def var de-vl-baixa-prev-me   as decimal no-undo.
def var i-aux                 as integer no-undo.
def var c-cd-maq-aux          as char format "x(01)".
def var l-imp                 as logical init yes.

def var h-bocx220             as handle  no-undo.
def var c-declaracao-import   as char    no-undo.
def var l-titulo-imp          as logical no-undo.
def var c-erro                as char    no-undo.
DEF VAR c-nr-embarque         AS CHAR    NO-UNDO.
DEF VAR c-embarque-aux        AS CHAR    NO-UNDO.

def var c-parc        as char    no-undo.
def var l-existe-tit  as logical no-undo.
def var l-erro-ems50  as logical no-undo.
DEF VAR c-serie-docto AS CHAR    NO-UNDO.
DEF VAR h-boar2011    AS HANDLE  NO-UNDO.

DEF VAR h-boec021          AS HANDLE  NO-UNDO. 
DEF VAR l-reembolso-gastos AS LOGICAL NO-UNDO. 
DEF VAR h-ecure9340        AS HANDLE  NO-UNDO. 

/* Utilizado pelo RE9340.i3 */
def var de-soma                    as decimal.
def var v-base-vl-percepcao        like tt-impto-tit-pend-ap.vl-percepcao.          
def var v-base-vl-percepcao-me     like tt-impto-tit-pend-ap.vl-percepcao-me.
def var v-base-vl-iva-liberado     like tt-impto-tit-pend-ap.vl-iva-liberado.  
def var v-base-vl-iva-liberado-me  like tt-impto-tit-pend-ap.vl-iva-liberado-me.   
def var v-base-vl-base-me          like tt-impto-tit-pend-ap.vl-base-me. 
def var v-base-vl-imposto-me       like tt-impto-tit-pend-ap.vl-imposto-me.
def var v-base-vl-saldo-imposto-me like tt-impto-tit-pend-ap.vl-saldo-imposto-me. 
def var v-base-vl-base             like tt-impto-tit-pend-ap.vl-base.       
def var v-base-vl-imposto          like tt-impto-tit-pend-ap.vl-imposto.     
def var v-base-vl-saldo-imposto    like tt-impto-tit-pend-ap.vl-saldo-imposto. 
def var v-vl-percepcao             like tt-impto-tit-pend-ap.vl-percepcao.          
def var v-vl-percepcao-me          like tt-impto-tit-pend-ap.vl-percepcao-me.
def var v-vl-iva-liberado          like tt-impto-tit-pend-ap.vl-iva-liberado.  
def var v-vl-iva-liberado-me       like tt-impto-tit-pend-ap.vl-iva-liberado-me.   
def var v-vl-base-me               like tt-impto-tit-pend-ap.vl-base-me. 
def var v-vl-imposto-me            like tt-impto-tit-pend-ap.vl-imposto-me.
def var v-vl-saldo-imposto-me      like tt-impto-tit-pend-ap.vl-saldo-imposto-me. 
def var v-vl-base                  like tt-impto-tit-pend-ap.vl-base.       
def var v-vl-imposto               like tt-impto-tit-pend-ap.vl-imposto.     
def var v-vl-saldo-imposto         like tt-impto-tit-pend-ap.vl-saldo-imposto. 
def var de-imposto                 as decimal.
def var de-imposto-me              as decimal.
def var i-ocor                     as int     no-undo.
DEF VAR i-cod-emitente-upc         AS INT     NO-UNDO.
DEF VAR de-tot-despesas            AS DEC     NO-UNDO.
DEF VAR de-total-imp-ret           AS DECIMAL                                    NO-UNDO.
DEF VAR de-total-imp-ret-me        AS DECIMAL                                    NO-UNDO.
DEF VAR l-autoretencion            AS LOGICAL                                    NO-UNDO.

IF NOT AVAIL param-global THEN
    find first param-global no-lock no-error.

/*
** Unidade de Neg¢cio
*/
&if defined(bf_mat_unidade_negocio) &then
    find first param-mat no-lock no-error.
&endif

find first docum-est
    where rowid(docum-est) = rw-docum-est no-lock no-error.

assign i-empresa-prin = param-global.empresa-prin.

&if defined (bf_dis_consiste_conta) &then

    find estabelec where
         estabelec.cod-estabel = docum-est.cod-estabel no-lock no-error.
    IF AVAIL estabelec THEN
        run cdp/cd9970.p (input rowid(estabelec),
                          output i-empresa-prin).
&endif
    
find first param-ap
    where param-ap.ep-codigo = i-empresa-prin  no-lock no-error.
    
find emitente use-index codigo
    where emitente.cod-emitente = docum-est.cod-emitente no-lock no-error.
    
IF NOT AVAIL param-estoq THEN
    find first param-estoq  no-lock no-error.
    
find param-re 
    where param-re.usuario = docum-est.usuario no-lock no-error.    

{rep/re1001a.i50} /* vari†veis e informaá‰es utilizadas pelo re1001a.i51 */
    
{cdp/cd4300.i4  "yes" docum-est.char-1} 

{rep/re1001a.i51 "yes"}

/* Retirado espaáos em branco na vari†vel c-embarque pois estava ocorrendo erro no ambiente oracle*/
ASSIGN c-embarque = TRIM(c-embarque).

/*
** Tratamento para nota de rateio
*/
for first natur-oper fields(nota-rateio)
    where natur-oper.nat-operacao = docum-est.nat-operacao no-lock:
    if natur-oper.nota-rateio then
        assign c-embarque = string(docum-est.nro-docto).    
end.

/*
** Geraá∆o dos T°tulos 
*/
bloco:
{rep/re9340.i8 " " " " "c-embarque"
               "i-mo-codigo"
               "de-vl-a-pagar-mo"
               "dupli-apagar.vl-a-pagar / de-vl-a-pagar-mo"}
               
/* 
** Criar provisao EMS 5.0
*/
if  l-ems50 then do:
    
    for each  tt-lin-i-ap
        where tt-lin-i-ap.ep-codigo   = i-empresa-prin
        and   tt-lin-i-ap.cod-estabel = docum-est.cod-estabel
        and   tt-lin-i-ap.serie       = docum-est.serie-docto
        and   tt-lin-i-ap.nr-docto    = c-embarque
        and   tt-lin-i-ap.cod-fornec  = docum-est.cod-emitente:        
    
        create tt-lin-i-ap-aux.
        buffer-copy tt-lin-i-ap to tt-lin-i-ap-aux.                       
        
        run imp/im9024.p( input docum-est.usuario,        
                          input i-sequencia,
                          input-output table tt-lin-i-ap-aux,
                          input-output table tt-l-pre-ap,
                          input-output table tt-erro ). 
                          
        find first tt-lin-i-ap-aux no-lock no-error.
                              
        delete tt-lin-i-ap-aux.                                  
              
    end.   

end.

/* 
** Procedures pi-monta-referencia e pi-cria-tt-lin-conta-ap 
*/

{rep/re9340.i9}

&endif

