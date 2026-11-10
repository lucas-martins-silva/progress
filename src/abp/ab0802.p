/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AB0802 2.00.00.008 } /*** "010008" ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i ab0802 MAB}
&ENDIF


/******************************************************************************
**
**      Programa...: ab0802
**
**      Objetivo...: Geracao de ACA ou EAC para ordens de manutencao de frota
*******************************************************************************/

/* Temp-tables para gerar a movimenta‡Æo em estoque */
{cdp/cd0666.i}      /* Definicao da temp-table de erros */   
{utp/ut-glob.i}
{cdp/cdcfgdis.i}
{cdp/cdcfgmat.i}
{cdp/cdcfgmnt.i}
{cdp/cd9911.i}

/* Temp-tables para gerar a movimenta‡Æo em estoque */

{cep/ceapi001k.i}   /* Definicao de temp-table do movto-estoq */

def input parameter r-registro as rowid no-undo.

def buffer b-movto     for movto-estoq.
def buffer b-item      for item.
def buffer b-movto-mat for movto-mat.
def buffer b-ordem     for ord-prod.
def buffer b-saldo     for saldo-estoq.

def var i-ct-codigo           like ord-prod.ct-codigo             no-undo.
def var i-sc-codigo           like ord-prod.sc-codigo             no-undo.
def var de-valor-mat-aca      like movto-estoq.valor-mat-m        no-undo. 
def var de-valor-mob-aca      like movto-estoq.valor-mob-m        no-undo. 
def var de-valor-ggf-aca      like movto-estoq.valor-ggf-m        no-undo.
def var de-valor-mat-eac      like movto-estoq.valor-mat-m        no-undo. 
def var de-valor-mob-eac      like movto-estoq.valor-mob-m        no-undo. 
def var de-valor-ggf-eac      like movto-estoq.valor-ggf-m        no-undo.
def var de-aux-mob-db         like movto-estoq.valor-mob-m        no-undo.
def var de-aux-mob-cr         like movto-estoq.valor-mob-m        no-undo.
def var de-aux-ggf-db         like movto-estoq.valor-ggf-m        no-undo.
def var de-aux-ggf-cr         like movto-estoq.valor-ggf-m        no-undo.
def var i-tmp-moe             like param-estoq.moeda1             no-undo. 
def var i-mo                  as integer                          no-undo. 
def var de-aux                as decimal decimals 2               no-undo.
def var i-cont                as integer                          no-undo.
def var i-y                   as integer                          no-undo.
def var i-x                   as integer                          no-undo.

def var i-empresa like param-global.empresa-prin no-undo.
/* Inicio das Variaveis para Matriz de Unidade de Negocio */
DEFINE VARIABLE de-tot-valor-mat-aca  LIKE movto-estoq.valor-mat-m NO-UNDO.
DEFINE VARIABLE de-tot-valor-mob-aca  LIKE movto-estoq.valor-mob-m NO-UNDO.
DEFINE VARIABLE de-tot-valor-ggf-aca  LIKE movto-estoq.valor-ggf-m NO-UNDO.

DEFINE VARIABLE de-tot-valor-mat-eac  LIKE movto-estoq.valor-mat-m NO-UNDO.
DEFINE VARIABLE de-tot-valor-ggf-eac  LIKE movto-estoq.valor-mob-m NO-UNDO.
DEFINE VARIABLE de-tot-valor-mob-eac  LIKE movto-estoq.valor-ggf-m NO-UNDO.

DEFINE VARIABLE valor-porc-mat-m      LIKE movto-estoq.valor-mat-m NO-UNDO.
DEFINE VARIABLE valor-porc-mob-m      LIKE movto-estoq.valor-mob-m NO-UNDO.
DEFINE VARIABLE valor-porc-ggf-m      LIKE movto-estoq.valor-ggf-m NO-UNDO.
DEFINE VARIABLE unidade-negocio       AS CHARACTER                 NO-UNDO.
DEFINE VARIABLE valor-total           AS DECIMAL                   NO-UNDO.
DEFINE VARIABLE maior-percentual      AS DECIMAL                   NO-UNDO.
DEFINE VARIABLE total-valor-mat-m     LIKE movto-estoq.valor-mat-m NO-UNDO.
DEFINE VARIABLE total-valor-ggf-m     LIKE movto-estoq.valor-ggf-m NO-UNDO.
DEFINE VARIABLE total-valor-mob-m     LIKE movto-estoq.valor-mob-m NO-UNDO.
/* Final das Variaveis para Matriz de Unidade de Negocio */

def shared var l-moeda-1    like param-estoq.tem-moeda1           no-undo.
def shared var l-moeda-2    like param-estoq.tem-moeda2           no-undo.
def shared var i-moeda-1    like param-estoq.moeda1               no-undo.
def shared var i-moeda-2    like param-estoq.moeda2               no-undo.
def shared var da-data-ini       as date    format "99/99/9999"   no-undo.
def shared var da-data-fim       as date    format "99/99/9999"   no-undo.
def shared var de-total-cre-mat  as decimal extent 3              no-undo.
def shared var de-total-cre-mob  as decimal decimals 02 extent 3  no-undo.
def shared var de-total-cre-ggf  as decimal decimals 02 extent 3  no-undo.
def shared var de-total-deb-mat  as decimal extent 3              no-undo.
def shared var de-total-deb-mob  as decimal decimals 02 extent 3  no-undo.
def shared var de-total-deb-ggf  as decimal decimals 02 extent 3  no-undo.
def shared var de-vl-ggf-cr      as decimal decimals 2  extent 18 no-undo.
def shared var de-vl-ggf-db      as decimal decimals 2  extent 18 no-undo.
def shared var de-vl-mob-cr      as decimal decimals 2  extent 3  no-undo.
def shared var de-vl-mob-db      as decimal decimals 2  extent 3  no-undo.
def shared var l-finalizar-programa as log                        no-undo.
def shared var i-seq-ocorrencia  as integer                       no-undo.
def shared var i-tipo-pr-med     as integer                       no-undo.
def shared var da-ult-fech-dia   as date format "99/99/9999"      no-undo.
def shared var da-inicio-calc    as date                          no-undo.
def shared var data-medio        as date                          no-undo.

DEFINE VARIABLE c-liter-ordem AS CHARACTER   NO-UNDO.

{utp/ut-liter.i Ordem *}
ASSIGN c-liter-ordem = RETURN-VALUE.

/* 
   A partir da release 2.04 as ocorrencias do medio passaram a 
   ser criadas por estabelecimento em funcao da possibilidade 
   de calcular o medio separadamente por estabelecimento
*/   
    
def shared temp-table tt-ocor-medio no-undo
    field it-codigo  like ocor-medio.it-codigo
    &if defined(bf_mat_fech_estab) &then
        field cod-estabel like ocor-medio.cod-estabel
    &endif    
    field ocorrencia like ocor-medio.ocorrencia
    index item it-codigo.  


for first ord-prod
    where rowid(ord-prod) = r-registro no-lock:
END.

for first mmv-ord-manut 
    where mmv-ord-manut.nr-ord-prod = ord-prod.nr-ord-prod no-lock:
END.

if not avail mmv-ord-manut then return.

FOR FIRST estabelec
    where estabelec.cod-estabel = mmv-ord-manut.cod-estabel NO-LOCK:
    FOR FIRST mmv-param
        WHERE mmv-param.ep-codigo = estabelec.ep-codigo NO-LOCK:
    END.
END.

IF NOT AVAIL mmv-param THEN do:
   FOR FIRST mmv-param NO-LOCK: 
   END.
END.

for first param-global no-lock:
END.

assign de-valor-mat-aca = 0
       de-valor-mob-aca = 0
       de-valor-ggf-aca = 0
       de-valor-mat-eac = 0
       de-valor-mob-eac = 0
       de-valor-ggf-eac = 0.

do i-mo = 1 to 3:
   if (i-mo = 2 and not l-moeda-1) or
      (i-mo = 3 and not l-moeda-2) then next.

   /* MATERIAL */
   assign de-aux = (de-total-deb-mat[i-mo]) - (de-total-cre-mat[i-mo]).

   if de-aux > 0 then 
      assign de-valor-mat-aca[i-mo] = de-aux.
   else 
      assign de-valor-mat-eac[i-mo] = de-aux * -1.

   /* GASTOS GERAIS DE FABRICA€ÇO */
   assign de-aux = (de-total-deb-ggf[i-mo]) - (de-total-cre-ggf[i-mo]).
   do i-y = 1 to 6:
      assign i-cont = (i-mo - 1) * 6 + i-y
             de-aux = de-aux + (de-vl-ggf-db[i-cont] - de-vl-ggf-cr[i-cont])
             de-aux-ggf-db[i-mo] = de-aux-ggf-db[i-mo] + de-vl-ggf-db[i-cont]
             de-aux-ggf-cr[i-mo] = de-aux-ggf-cr[i-mo] + de-vl-ggf-cr[i-cont].
   end.           

   if de-aux > 0 then 
      assign de-valor-ggf-aca[i-mo] = de-aux.
   else 
      assign de-valor-ggf-eac[i-mo] = de-aux * -1.
      
   /* MÇO-DE-OBRA DIRETA */
   assign de-aux = (de-total-deb-mob[i-mo]) -
                   (de-total-cre-mob[i-mo]).
                   
   assign de-aux = de-aux + (de-vl-mob-db[i-mo] - de-vl-mob-cr[i-mo])
          de-aux-mob-db[i-mo] = de-aux-mob-db[i-mo] + de-vl-mob-db[i-mo]
          de-aux-mob-cr[i-mo] = de-aux-mob-cr[i-mo] + de-vl-mob-cr[i-mo].                   

   if de-aux > 0 then 
      assign de-valor-mob-aca[i-mo] = de-aux.
   else 
      assign de-valor-mob-eac[i-mo] = de-aux * -1.   

end.

if de-valor-mat-aca[1] = 0 and
   de-valor-mat-aca[2] = 0 and
   de-valor-mat-aca[3] = 0 and   
   de-valor-mob-aca[1] = 0 and
   de-valor-mob-aca[2] = 0 and
   de-valor-mob-aca[3] = 0 and   
   de-valor-ggf-aca[1] = 0 and
   de-valor-ggf-aca[2] = 0 and
   de-valor-ggf-aca[3] = 0 and   
   de-valor-mat-eac[1] = 0 and
   de-valor-mat-eac[2] = 0 and
   de-valor-mat-eac[3] = 0 and   
   de-valor-mob-eac[1] = 0 and
   de-valor-mob-eac[2] = 0 and
   de-valor-mob-eac[3] = 0 and   
   de-valor-ggf-eac[1] = 0 and
   de-valor-ggf-eac[2] = 0 and
   de-valor-ggf-eac[3] = 0 AND
   de-total-deb-mat[1] = 0 AND
   de-total-cre-mat[1] = 0 AND
   de-total-deb-mat[2] = 0 AND 
   de-total-cre-mat[2] = 0 AND
   de-total-deb-mat[3] = 0 AND
   de-total-cre-mat[3] = 0
then return.

assign i-ct-codigo = ord-prod.ct-desp
       i-sc-codigo = ord-prod.sc-desp.
       
assign i-empresa = param-global.empresa-prin.
  
/*Devito ao projeto 105 essa tabela n dve mais ser usada.
for first conta-contab
    where conta-contab.ep-codigo = i-empresa
    and   conta-contab.ct-codigo = i-ct-codigo
    and   conta-contab.sc-codigo = i-sc-codigo
    no-lock : end.*/

find first b-ordem where 
           rowid(b-ordem) = rowid(ord-prod) 
           exclusive-lock no-error.
if  avail  b-ordem then
    assign b-ordem.calc-cs-mat  = 2
           b-ordem.calc-cs-mob  = 2     
           b-ordem.calc-cs-ggf  = 2
           b-ordem.qt-produzida = 1. 

for first b-item 
    where b-item.it-codigo = mmv-param.it-codigo no-lock:
END.
    
find first b-saldo
     where b-saldo.cod-estabel = ord-prod.cod-estabel
     and   b-saldo.it-codigo   = mmv-param.it-codigo
     no-lock no-error.
if not avail b-saldo then
   find first b-saldo
         where b-saldo.cod-estabel = ord-prod.cod-estabel
         no-lock no-error.
         

if de-valor-mat-aca[1] + 
   de-valor-mat-aca[2] + 
   de-valor-mat-aca[3] +   
   de-valor-mob-aca[1] + 
   de-valor-mob-aca[2] +
   de-valor-mob-aca[3] +
   de-valor-ggf-aca[1] +
   de-valor-ggf-aca[2] +
   de-valor-ggf-aca[3] > 0 then do:
   &IF DEFINED(bf_mnt_ems206b) &THEN
       
       /* Somente entra quando nÆo tem matriz de unidade de neg¢cio */
       IF  NOT CAN-FIND(FIRST mmv-unid-negoc-om
                        WHERE mmv-unid-negoc-om.nr-ord-produ = mmv-ord-manut.nr-ord-produ) OR NOT l-usa-unid-negoc THEN DO:

           CREATE tt-movto.
           ASSIGN tt-movto.cod-versao-integ = 1
                  tt-movto.cod-prog-orig    = "AB0802.P"
                  tt-movto.cod-estabel      = ord-prod.cod-estabel   
                  tt-movto.cod-depos        = ord-prod.cod-depos
                  tt-movto.cod-localiz      = b-item.cod-localiz
                  tt-movto.lote             = b-saldo.lote
                  tt-movto.cod-refer        = b-item.cod-refer           
                  tt-movto.it-codigo        = mmv-param.it-codigo    
                  tt-movto.nr-ord-prod      = mmv-ord-manut.nr-ord-produ
                  tt-movto.nro-docto        = STRING(mmv-ord-manut.nr-ord-produ)
                  tt-movto.ct-codigo        = ord-prod.ct-codigo
                  tt-movto.sc-codigo        = ord-prod.sc-codigo
                  tt-movto.tipo-val         = 2
                  tt-movto.dt-trans         = da-data-fim
                  tt-movto.quantidade       = 1
                  tt-movto.un               = b-item.un
                  tt-movto.usuario          = c-seg-usuario
                  tt-movto.ct-db            = ord-prod.ct-desp
                  tt-movto.sc-db            = ord-prod.sc-desp
                  tt-movto.dt-vali-lote     = 12/31/2999
                  tt-movto.descricao-db     = "".
           DO i-x = 1 TO 3:
              ASSIGN tt-movto.valor-mat-m[i-x] = de-valor-mat-aca[i-x]
                     tt-movto.valor-mob-m[i-x] = de-valor-mob-aca[i-x]
                     tt-movto.valor-ggf-m[i-x] = de-valor-ggf-aca[i-x].
           END.
           ASSIGN tt-movto.tipo-trans = 1
                  tt-movto.esp-docto  = 1.
       
           {cep/ce0401.i02}
    
       END.
       ELSE DO:

           FOR EACH mmv-unid-negoc-om
               WHERE mmv-unid-negoc-om.nr-ord-produ = ord-prod.nr-ord-produ NO-LOCK
               BREAK BY mmv-unid-negoc-om.nr-ord-produ.

               DO i-x = 1 TO 3:
                   ASSIGN valor-porc-mat-m[i-x] = ROUND(de-valor-mat-aca[i-x] * mmv-unid-negoc-om.val-perc-unid-negoc / 100 ,2)
                          valor-porc-mob-m[i-x] = ROUND(de-valor-mob-aca[i-x] * mmv-unid-negoc-om.val-perc-unid-negoc / 100 ,2)
                          valor-porc-ggf-m[i-x] = ROUND(de-valor-ggf-aca[i-x] * mmv-unid-negoc-om.val-perc-unid-negoc / 100 ,2).
    
                   /* valor do rateio acumulado */
                   ASSIGN de-tot-valor-mat-aca[i-x]  = ROUND(de-tot-valor-mat-aca[i-x] + valor-porc-mat-m[i-x] , 2)
                          de-tot-valor-mob-aca[i-x]  = ROUND(de-tot-valor-mob-aca[i-x] + valor-porc-mob-m[i-x] , 2)
                          de-tot-valor-ggf-aca[i-x]  = ROUND(de-tot-valor-ggf-aca[i-x] + valor-porc-ggf-m[i-x] , 2).
    
                  /** Calculo da diferen‡a **/
                  IF  LAST-OF(mmv-unid-negoc-om.nr-ord-produ) THEN DO:
                      ASSIGN total-valor-mat-m[i-x] = de-valor-mat-aca[i-x] - de-tot-valor-mat-aca[i-x]
                             total-valor-mob-m[i-x] = de-valor-mob-aca[i-x] - de-tot-valor-mob-aca[i-x]
                             total-valor-ggf-m[i-x] = de-valor-ggf-aca[i-x] - de-tot-valor-ggf-aca[i-x].
                  END.
               END.
    
               IF  mmv-unid-negoc-om.val-perc-unid-negoc > maior-percentual THEN DO:
                   ASSIGN maior-percentual    = mmv-unid-negoc-om.val-perc-unid-negoc
                          unidade-negocio     = mmv-unid-negoc-om.cod-unid-negoc.
               END.
    
           END.
    
           FOR EACH mmv-unid-negoc-om
               WHERE mmv-unid-negoc-om.nr-ord-produ = mmv-ord-manut.nr-ord-produ NO-LOCK:
    
               CREATE tt-movto.
               ASSIGN tt-movto.cod-versao-integ = 1
                      tt-movto.cod-prog-orig    = "AB0802.P"
                      tt-movto.cod-estabel      = ord-prod.cod-estabel   
                      tt-movto.cod-depos        = ord-prod.cod-depos
                      tt-movto.cod-localiz      = b-item.cod-localiz
                      tt-movto.lote             = b-saldo.lote
                      tt-movto.cod-refer        = b-item.cod-refer           
                      tt-movto.it-codigo        = mmv-param.it-codigo    
                      tt-movto.nr-ord-prod      = mmv-ord-manut.nr-ord-produ
                      tt-movto.nro-docto        = STRING(mmv-ord-manut.nr-ord-produ)
                      tt-movto.ct-codigo        = ord-prod.ct-codigo
                      tt-movto.sc-codigo        = ord-prod.sc-codigo
                      tt-movto.tipo-val         = 2
                      tt-movto.dt-trans         = da-data-fim
                      tt-movto.quantidade       = 1
                      tt-movto.un               = b-item.un
                      tt-movto.usuario          = c-seg-usuario
                      tt-movto.ct-db            = ord-prod.ct-desp  
                      tt-movto.sc-db            = ord-prod.sc-desp
                      tt-movto.dt-vali-lote     = 12/31/2999
                      tt-movto.descricao-db     = ""
                      tt-movto.cod-unid-negoc   = ord-prod.cod-unid-negoc
                      tt-movto.cod-unid-negoc-db = mmv-unid-negoc-om.cod-unid-negoc.
    
               DO  i-x = 1 TO 3:
                   ASSIGN tt-movto.valor-mat-m[i-x] = ROUND(de-valor-mat-aca[i-x] * mmv-unid-negoc-om.val-perc-unid-negoc / 100 , 2)
                          tt-movto.valor-mob-m[i-x] = ROUND(de-valor-mob-aca[i-x] * mmv-unid-negoc-om.val-perc-unid-negoc / 100 , 2)
                          tt-movto.valor-ggf-m[i-x] = ROUND(de-valor-ggf-aca[i-x] * mmv-unid-negoc-om.val-perc-unid-negoc / 100 , 2).
                   ASSIGN de-tot-valor-mat-aca[i-x] = ROUND(de-valor-mat-aca[i-x] + tt-movto.valor-mat-m[i-x] , 2)
                          de-tot-valor-mob-aca[i-x] = ROUND(de-valor-mob-aca[i-x] + tt-movto.valor-mob-m[i-x] , 2)
                          de-tot-valor-ggf-aca[i-x] = ROUND(de-valor-ggf-aca[i-x] + tt-movto.valor-ggf-m[i-x] , 2).
               END.
    
               IF  mmv-unid-negoc-om.cod-unid-negoc = unidade-negocio THEN DO:
                   DO i-x = 1 TO 3:
                       ASSIGN tt-movto.valor-mat-m[i-x]  = ROUND(tt-movto.valor-mat-m[i-x] + total-valor-mat-m[i-x] , 2)
                              tt-movto.valor-mob-m[i-x]  = ROUND(tt-movto.valor-mob-m[i-x] + total-valor-mob-m[i-x] , 2)
                              tt-movto.valor-ggf-m[i-x]  = ROUND(tt-movto.valor-ggf-m[i-x] + total-valor-ggf-m[i-x] , 2).
                   END.
               END.
           
               ASSIGN tt-movto.tipo-trans = 1
                      tt-movto.esp-docto  = 1.
           
               {cep/ce0401.i02}
               
           END.
       END.

   &ELSE
   
       CREATE tt-movto.
       ASSIGN tt-movto.cod-versao-integ = 1
              tt-movto.cod-prog-orig    = "AB0802.P"
              tt-movto.cod-estabel      = ord-prod.cod-estabel   
              tt-movto.cod-depos        = ord-prod.cod-depos
              tt-movto.cod-localiz      = b-item.cod-localiz
              tt-movto.lote             = b-saldo.lote
              tt-movto.cod-refer        = b-item.cod-refer           
              tt-movto.it-codigo        = mmv-param.it-codigo    
              tt-movto.nr-ord-prod      = mmv-ord-manut.nr-ord-produ
              tt-movto.nro-docto        = STRING(mmv-ord-manut.nr-ord-produ)
              tt-movto.ct-codigo        = ord-prod.ct-codigo
              tt-movto.sc-codigo        = ord-prod.sc-codigo
              tt-movto.tipo-val         = 2
              tt-movto.dt-trans         = da-data-fim
              tt-movto.quantidade       = 1
              tt-movto.un               = b-item.un
              tt-movto.usuario          = c-seg-usuario
              tt-movto.ct-db            = ord-prod.ct-desp
              tt-movto.sc-db            = ord-prod.sc-desp
              tt-movto.dt-vali-lote     = 12/31/2999
              tt-movto.descricao-db     = "".

       DO i-x = 1 TO 3:
          ASSIGN tt-movto.valor-mat-m[i-x] = de-valor-mat-aca[i-x]
                 tt-movto.valor-mob-m[i-x] = de-valor-mob-aca[i-x]
                 tt-movto.valor-ggf-m[i-x] = de-valor-ggf-aca[i-x].
       END.
       ASSIGN tt-movto.tipo-trans = 1
              tt-movto.esp-docto  = 1.
    
       {cep/ce0401.i02}
   &ENDIF

end.

if de-valor-mat-eac[1] + 
   de-valor-mat-eac[2] + 
   de-valor-mat-eac[3] +
   de-valor-mob-eac[1] + 
   de-valor-mob-eac[2] +
   de-valor-mob-eac[3] + 
   de-valor-ggf-eac[1] +
   de-valor-ggf-eac[2] +
   de-valor-ggf-eac[3] > 0 then do:

   &IF DEFINED(bf_mnt_ems206b) &THEN
        FOR EACH mmv-unid-negoc-om
            WHERE mmv-unid-negoc-om.nr-ord-produ = ord-prod.nr-ord-produ NO-LOCK
            BREAK BY mmv-unid-negoc-om.nr-ord-produ.
    
            DO i-x = 1 TO 3:
                ASSIGN valor-porc-mat-m[i-x] = ROUND(de-valor-mat-eac[i-x] * mmv-unid-negoc-om.val-perc-unid-negoc / 100 , 2)
                       valor-porc-mob-m[i-x] = ROUND(de-valor-mob-eac[i-x] * mmv-unid-negoc-om.val-perc-unid-negoc / 100 , 2)
                       valor-porc-ggf-m[i-x] = ROUND(de-valor-ggf-eac[i-x] * mmv-unid-negoc-om.val-perc-unid-negoc / 100 , 2).
    
    
                /* valor do rateio acumulado */
                assign de-tot-valor-mat-eac[i-x]  = round(de-tot-valor-mat-eac[i-x]   + valor-porc-mat-m[i-x] , 2)
                       de-tot-valor-mob-eac[i-x]  = round(de-tot-valor-mob-eac[i-x]   + valor-porc-mob-m[i-x] , 2)
                       de-tot-valor-ggf-eac[i-x]  = round(de-tot-valor-ggf-eac[i-x]   + valor-porc-ggf-m[i-x] , 2).
    
               /** Calculo da difereca **/
               IF LAST-OF(mmv-unid-negoc-om.nr-ord-produ) THEN DO:
                    ASSIGN total-valor-mat-m[i-x] =    de-valor-mat-eac[i-x] - de-tot-valor-mat-eac[i-x]
                           total-valor-mob-m[i-x] =    de-valor-mob-eac[i-x] - de-tot-valor-mob-eac[i-x]
                           total-valor-ggf-m[i-x] =    de-valor-ggf-eac[i-x] - de-tot-valor-ggf-eac[i-x].
                END.
            END.
    
            IF  mmv-unid-negoc-om.val-perc-unid-negoc > maior-percentual THEN DO:
                 ASSIGN maior-percentual    = mmv-unid-negoc-om.val-perc-unid-negoc
                        unidade-negocio     = mmv-unid-negoc-om.cod-unid-negoc.
            END.
        END.

   
        IF  NOT CAN-FIND(FIRST mmv-unid-negoc-om
                         WHERE mmv-unid-negoc-om.nr-ord-produ = ord-prod.nr-ord-produ) OR NOT l-usa-unid-negoc THEN DO:

            CREATE tt-movto.
            ASSIGN tt-movto.cod-versao-integ = 1
                   tt-movto.cod-prog-orig    = "AB0802.P"
                   tt-movto.cod-estabel      = ord-prod.cod-estabel   
                   tt-movto.cod-depos        = ord-prod.cod-depos
                   tt-movto.cod-localiz      = b-item.cod-localiz
                   tt-movto.lote             = b-saldo.lote
                   tt-movto.cod-refer        = b-item.cod-refer   
                   tt-movto.it-codigo        = mmv-param.it-codigo
                   tt-movto.nr-ord-prod      = mmv-ord-manut.nr-ord-produ
                   tt-movto.nro-docto        = STRING(mmv-ord-manut.nr-ord-produ)
                   tt-movto.ct-codigo        = ord-prod.ct-codigo
                   tt-movto.sc-codigo        = ord-prod.sc-codigo
                   tt-movto.dt-trans         = da-data-fim
                   tt-movto.quantidade       = 1
                   tt-movto.tipo-val         = 2
                   tt-movto.un               = b-item.un
                   tt-movto.ct-db            = ord-prod.ct-desp
                   tt-movto.sc-db            = ord-prod.sc-desp
                   tt-movto.usuario          = c-seg-usuario
                   tt-movto.dt-vali-lote     = 12/31/2999
                   tt-movto.descricao-db     = "".
    
            DO i-x = 1 TO 3:
               ASSIGN tt-movto.valor-mat-m[i-x] = de-valor-mat-eac[i-x]
                      tt-movto.valor-ggf-m[i-x] = de-valor-ggf-eac[i-x]
                      tt-movto.valor-mob-m[i-x] = de-valor-mob-eac[i-x].
            END.
            ASSIGN tt-movto.tipo-trans   = 2
                   tt-movto.esp-docto    = 8.
    
            {cep/ce0401.i02}
    
       END.
       ELSE DO:

           FOR EACH mmv-unid-negoc-om
               WHERE mmv-unid-negoc-om.nr-ord-produ = mmv-ord-manut.nr-ord-produ NO-LOCK:

               CREATE tt-movto.
               ASSIGN tt-movto.cod-versao-integ = 1
                      tt-movto.cod-prog-orig    = "AB0802.P"
                      tt-movto.cod-estabel      = ord-prod.cod-estabel   
                      tt-movto.cod-depos        = ord-prod.cod-depos
                      tt-movto.cod-localiz      = b-item.cod-localiz
                      tt-movto.lote             = b-saldo.lote
                      tt-movto.cod-refer        = b-item.cod-refer   
                      tt-movto.it-codigo        = mmv-param.it-codigo
                      tt-movto.nr-ord-prod      = mmv-ord-manut.nr-ord-produ
                      tt-movto.nro-docto        = STRING(mmv-ord-manut.nr-ord-produ)
                      tt-movto.ct-codigo        = ord-prod.ct-codigo
                      tt-movto.sc-codigo        = ord-prod.sc-codigo
                      tt-movto.dt-trans         = da-data-fim
                      tt-movto.quantidade       = 1
                      tt-movto.tipo-val         = 2
                      tt-movto.un               = b-item.un
                      tt-movto.ct-db            = ord-prod.ct-desp
                      tt-movto.sc-db            = ord-prod.sc-desp
                      tt-movto.usuario          = c-seg-usuario
                      tt-movto.dt-vali-lote     = 12/31/2999
                      tt-movto.descricao-db     = ""
                      tt-movto.cod-unid-negoc    = ord-prod.cod-unid-negoc
                      tt-movto.cod-unid-negoc-db = mmv-unid-negoc-om.cod-unid-negoc.

               DO i-x = 1 TO 3:
                   ASSIGN tt-movto.valor-mat-m[i-x] = ROUND(de-valor-mat-eac[i-x] * mmv-unid-negoc-om.val-perc-unid-negoc / 100 , 2) 
                          tt-movto.valor-ggf-m[i-x] = ROUND(de-valor-ggf-eac[i-x] * mmv-unid-negoc-om.val-perc-unid-negoc / 100 , 2) 
                          tt-movto.valor-mob-m[i-x] = ROUND(de-valor-mob-eac[i-x] * mmv-unid-negoc-om.val-perc-unid-negoc / 100 , 2).
        
                   ASSIGN de-tot-valor-mat-eac[i-x] = ROUND(de-valor-mat-eac[i-x] + tt-movto.valor-mat-m[i-x] , 2) 
                          de-tot-valor-ggf-eac[i-x] = ROUND(de-valor-ggf-eac[i-x] + tt-movto.valor-ggf-m[i-x] , 2)
                          de-tot-valor-mob-eac[i-x] = ROUND(de-valor-mob-eac[i-x] + tt-movto.valor-mob-m[i-x] , 2).
               END.
        
        
               IF  mmv-unid-negoc-om.cod-unid-negoc = unidade-negocio  THEN DO:
                    do i-x = 1 to 3:
                        ASSIGN tt-movto.valor-mat-m[i-x]  = round(tt-movto.valor-mat-m[i-x] + total-valor-mat-m[i-x] , 2)
                               tt-movto.valor-ggf-m[i-x]  = round(tt-movto.valor-ggf-m[i-x] + total-valor-ggf-m[i-x] , 2)
                               tt-movto.valor-mob-m[i-x]  = round(tt-movto.valor-mob-m[i-x] + total-valor-mob-m[i-x] , 2).
                    END.
               END.
               assign tt-movto.tipo-trans = 2
                      tt-movto.esp-docto  = 8.
               {cep/ce0401.i02}
           END.
       END.
   
   &ELSE
   
       CREATE tt-movto.
       ASSIGN tt-movto.cod-versao-integ = 1
              tt-movto.cod-prog-orig    = "AB0802.P"
              tt-movto.cod-estabel      = ord-prod.cod-estabel   
              tt-movto.cod-depos        = ord-prod.cod-depos
              tt-movto.cod-localiz      = b-item.cod-localiz
              tt-movto.lote             = b-saldo.lote
              tt-movto.cod-refer        = b-item.cod-refer   
              tt-movto.it-codigo        = mmv-param.it-codigo
              tt-movto.nr-ord-prod      = mmv-ord-manut.nr-ord-produ
              tt-movto.nro-docto        = STRING(mmv-ord-manut.nr-ord-produ)
              tt-movto.ct-codigo        = ord-prod.ct-codigo
              tt-movto.sc-codigo        = ord-prod.sc-codigo
              tt-movto.dt-trans         = da-data-fim
              tt-movto.quantidade       = 1
              tt-movto.tipo-val         = 2
              tt-movto.un               = b-item.un
              tt-movto.ct-db            = ord-prod.ct-desp
              tt-movto.sc-db            = ord-prod.sc-desp
              tt-movto.usuario          = c-seg-usuario
              tt-movto.dt-vali-lote     = 12/31/2999
              tt-movto.descricao-db     = "".

       DO i-x = 1 TO 3:
          ASSIGN tt-movto.valor-mat-m[i-x] = de-valor-mat-eac[i-x]
                 tt-movto.valor-ggf-m[i-x] = de-valor-ggf-eac[i-x]
                 tt-movto.valor-mob-m[i-x] = de-valor-mob-eac[i-x].
       END.
       ASSIGN tt-movto.tipo-trans   = 2
              tt-movto.esp-docto    = 8.

       {cep/ce0401.i02}

   &ENDIF

end.
/*
/* Chama a api do estoque e grava as ocorrˆncias do m‚dio */
{cep/ce0401.i12 mmv-param.it-codigo ord-prod.cod-estabel} 
*/
&IF DEFINED(bf_mnt_ems206b) &THEN
/* Chama a api do estoque e grava as ocorrˆncias do m‚dio */
    DEFINE VAR hCeapi001k AS HANDLE   NO-UNDO.
    RUN cep/ceapi001k.p PERSISTENT SET hCeapi001k.

    {cep/ce0401.i35 mmv-param.it-codigo ord-prod.cod-estabel}
    
    RUN pi-elimina-handle.

&ELSE
/* Chama a api do estoque e grava as ocorrˆncias do m‚dio */
    {cep/ce0401.i12 mmv-param.it-codigo ord-prod.cod-estabel}
&ENDIF

PROCEDURE pi-elimina-handle.

    &IF DEFINED(bf_mnt_ems206b) &THEN
        /* Elimina handle */
        IF VALID-HANDLE (hCeapi001k) THEN DO: 
            RUN pi-deleta-handle IN hCeapi001k.
            DELETE procedure hCeapi001k.
        END.
    &ENDIF
    
END PROCEDURE.

for each movto-mat where movto-mat.nr-ord-prod = ord-prod.nr-ord-prod
                     and movto-mat.it-codigo   = ord-prod.it-codigo
                     and movto-mat.dt-trans    = data-medio
                     and (movto-mat.esp-docto  = 1 or
                          movto-mat.esp-docto  = 8) exclusive-lock:
    do i-mo = 1 to 3:
        assign movto-mat.vl-ggf-c-m[i-mo] = movto-mat.valor-ggf-m[i-mo]
               movto-mat.vl-mob-c-m[i-mo] = movto-mat.valor-mob-m[i-mo].
    end.
end.

do i-mo = 1 to 3:
  if i-mo = 1 or (i-mo = 2 and l-moeda-1)
              or (i-mo = 3 and l-moeda-2) then do:

    assign i-tmp-moe = if i-mo = 1 then 0
                       else if i-mo = 2 then i-moeda-1
                            else i-moeda-2.

    find ext-ord use-index ordem where
         ext-ord.nr-ord-prod = ord-prod.nr-ord-prod and
         ext-ord.mo-codigo   = i-tmp-moe            and
         ext-ord.op-seq      = 0 exclusive-lock no-error.
 
    if not avail ext-ord then do:
       create ext-ord.
       assign ext-ord.nr-ord-prod = ord-prod.nr-ord-prod
              ext-ord.mo-codigo   = i-tmp-moe
              ext-ord.op-seq      = 0.
    end.
           /* Material */
    assign ext-ord.vl-mat-deb-m   = ext-ord.vl-mat-deb-m     + de-total-deb-mat[i-mo]
           ext-ord.vl-mat-cre-m   = ext-ord.vl-mat-cre-m     + de-total-cre-mat[i-mo]
        
           /* Mao-de-Obra Direta do Acabado */
           ext-ord.vl-mob-deb-m   = ext-ord.vl-mob-deb-m     + de-vl-mob-db[i-mo]
           ext-ord.vl-mob-cre-m   = ext-ord.vl-mob-cre-m     + de-vl-mob-cr[i-mo]              
      
           /* Mao-de-Obra Direta do Componente */
           ext-ord.vl-mob-db-c-m  = ext-ord.vl-mob-db-c-m    + de-total-deb-mob[i-mo]
           ext-ord.vl-mob-cr-c-m  = ext-ord.vl-mob-cr-c-m    + de-total-cre-mob[i-mo]
      
           /* Valor GGF do Componente */
           ext-ord.vl-ggf-db-c-m  = ext-ord.vl-ggf-db-c-m    + de-total-deb-ggf[i-mo]
           ext-ord.vl-ggf-cr-c-m  = ext-ord.vl-ggf-cr-c-m    + de-total-cre-ggf[i-mo].
       
    /* Valor GGF do Acabado */
    do i-y = 1 to 6:
       assign i-cont                  = (i-mo - 1) * 6 + i-y
              ext-ord.vl-ggf-deb-m[i-y]   = ext-ord.vl-ggf-deb-m[i-y] + de-vl-ggf-db[i-cont]
              ext-ord.vl-ggf-cre-m[i-y]   = ext-ord.vl-ggf-cre-m[i-y] + de-vl-ggf-cr[i-cont].
    end.

  
    /* Atualizacao do Ext-ord do mes. Valores da ordem acumulados somente no periodo corrente.        
       Se for calculo do preco medio diario e nao for a primeira execucao do calculo no mes 
       corrente, acumula com os valores ja armazenados no mes. */

    assign ext-ord.vl-mt-db-mes-m = ext-ord.vl-mt-db-mes-m + de-total-deb-mat[i-mo]
           ext-ord.vl-mt-cr-mes-m = ext-ord.vl-mt-cr-mes-m + de-total-cre-mat[i-mo]
           ext-ord.vl-mb-db-mes-m = ext-ord.vl-mb-db-mes-m + de-vl-mob-db[i-mo]  
           ext-ord.vl-mb-cr-mes-m = ext-ord.vl-mb-cr-mes-m + de-vl-mob-cr[i-mo]  
           ext-ord.vl-mob-db-me-m = ext-ord.vl-mob-db-me-m + de-total-deb-mob[i-mo]
           ext-ord.vl-mob-cr-me-m = ext-ord.vl-mob-cr-me-m + de-total-cre-mob[i-mo]       
           ext-ord.vl-ggf-db-me-m = ext-ord.vl-ggf-db-me-m + de-total-deb-ggf[i-mo]
           ext-ord.vl-ggf-cr-me-m = ext-ord.vl-ggf-cr-me-m + de-total-cre-ggf[i-mo].       
    do i-y = 1 to 6:          
       assign i-cont                  = (i-mo - 1) * 6 + i-y
              ext-ord.vl-gf-db-mes-m[i-y] = ext-ord.vl-gf-db-mes-m[i-y] + de-vl-ggf-db[i-cont]
              ext-ord.vl-gf-cr-mes-m[i-y] = ext-ord.vl-gf-cr-mes-m[i-y] + de-vl-ggf-cr[i-cont].      
    end.  
  end.
end.
