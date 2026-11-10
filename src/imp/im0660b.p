/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i EX0105B 2.00.00.003}  /*** 010003 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i EX0105B MIM}
&ENDIF


PROCEDURE literaisEspec:
/*------------------------------------------------------------------------------
  Objetivo:    Substitui‡Æo dos campos espec¡ficos pelos labels/literais desejados.
  Parƒmetros:  p-literal    : literal a ser substitu¡da no arquivo .doc gerado
               p-valor-label: valor do label … ser mostrado no arquivo .doc gerado
------------------------------------------------------------------------------*/
    
    DEFINE INPUT  PARAMETER p-literal       AS CHARACTER  NO-UNDO.
    DEFINE OUTPUT PARAMETER p-valor-literal AS CHARACTER  NO-UNDO.
 
    CASE p-literal:
        WHEN "#lit-var-espec-cabec-1"  THEN ASSIGN p-valor-literal = "<valor do label da vari vel #lit-var-espec-cabec-1>".
        WHEN "#lit-var-espec-cabec-2"  THEN ASSIGN p-valor-literal = "<valor do label da vari vel #lit-var-espec-cabec-2>".
        WHEN "#lit-var-espec-cabec-3"  THEN ASSIGN p-valor-literal = "<valor do label da vari vel #lit-var-espec-cabec-3>".
        WHEN "#lit-var-espec-cabec-4"  THEN ASSIGN p-valor-literal = "<valor do label da vari vel #lit-var-espec-cabec-4>".
        WHEN "#lit-var-espec-cabec-5"  THEN ASSIGN p-valor-literal = "<valor do label da vari vel #lit-var-espec-cabec-5>".
        WHEN "#lit-var-espec-cabec-6"  THEN ASSIGN p-valor-literal = "<valor do label da vari vel #lit-var-espec-cabec-6>".
        WHEN "#lit-var-espec-cabec-7"  THEN ASSIGN p-valor-literal = "<valor do label da vari vel #lit-var-espec-cabec-7>".
        WHEN "#lit-var-espec-cabec-8"  THEN ASSIGN p-valor-literal = "<valor do label da vari vel #lit-var-espec-cabec-8>".
        WHEN "#lit-var-espec-cabec-9"  THEN ASSIGN p-valor-literal = "<valor do label da vari vel #lit-var-espec-cabec-9>".
        WHEN "#lit-var-espec-cabec-10" THEN ASSIGN p-valor-literal = "<valor do label da vari vel #lit-var-espec-cabec-10>".
        WHEN "#lit-var-espec-cabec-11" THEN ASSIGN p-valor-literal = "<valor do label da vari vel #lit-var-espec-cabec-11>".
        WHEN "#lit-var-espec-cabec-12" THEN ASSIGN p-valor-literal = "<valor do label da vari vel #lit-var-espec-cabec-12>".
        WHEN "#lit-var-espec-cabec-13" THEN ASSIGN p-valor-literal = "<valor do label da vari vel #lit-var-espec-cabec-13>".
        WHEN "#lit-var-espec-cabec-14" THEN ASSIGN p-valor-literal = "<valor do label da vari vel #lit-var-espec-cabec-14>".
        WHEN "#lit-var-espec-cabec-15" THEN ASSIGN p-valor-literal = "<valor do label da vari vel #lit-var-espec-cabec-15>".
        WHEN "#lit-var-espec-cabec-16" THEN ASSIGN p-valor-literal = "<valor do label da vari vel #lit-var-espec-cabec-16>".
        WHEN "#lit-var-espec-cabec-17" THEN ASSIGN p-valor-literal = "<valor do label da vari vel #lit-var-espec-cabec-17>".
        WHEN "#lit-var-espec-cabec-18" THEN ASSIGN p-valor-literal = "<valor do label da vari vel #lit-var-espec-cabec-18>".
        WHEN "#lit-var-espec-cabec-19" THEN ASSIGN p-valor-literal = "<valor do label da vari vel #lit-var-espec-cabec-19>".
        WHEN "#lit-var-espec-cabec-20" THEN ASSIGN p-valor-literal = "<valor do label da vari vel #lit-var-espec-cabec-20>".
        
        WHEN "#lit-var-espec-pedidos-1"  THEN ASSIGN p-valor-literal = "<valor do label da vari vel #lit-var-espec-pedidos-1>".
        WHEN "#lit-var-espec-pedidos-2"  THEN ASSIGN p-valor-literal = "<valor do label da vari vel #lit-var-espec-pedidos-2>".
        WHEN "#lit-var-espec-pedidos-3"  THEN ASSIGN p-valor-literal = "<valor do label da vari vel #lit-var-espec-pedidos-3>".
        WHEN "#lit-var-espec-pedidos-4"  THEN ASSIGN p-valor-literal = "<valor do label da vari vel #lit-var-espec-pedidos-4>".
        WHEN "#lit-var-espec-pedidos-5"  THEN ASSIGN p-valor-literal = "<valor do label da vari vel #lit-var-espec-pedidos-5>".
        WHEN "#lit-var-espec-pedidos-6"  THEN ASSIGN p-valor-literal = "<valor do label da vari vel #lit-var-espec-pedidos-6>".
        WHEN "#lit-var-espec-pedidos-7"  THEN ASSIGN p-valor-literal = "<valor do label da vari vel #lit-var-espec-pedidos-7>".
        WHEN "#lit-var-espec-pedidos-8"  THEN ASSIGN p-valor-literal = "<valor do label da vari vel #lit-var-espec-pedidos-8>".
        WHEN "#lit-var-espec-pedidos-9"  THEN ASSIGN p-valor-literal = "<valor do label da vari vel #lit-var-espec-pedidos-9>".
        WHEN "#lit-var-espec-pedidos-10" THEN ASSIGN p-valor-literal = "<valor do label da vari vel #lit-var-espec-pedidos-10>".
        WHEN "#lit-var-espec-pedidos-11" THEN ASSIGN p-valor-literal = "<valor do label da vari vel #lit-var-espec-pedidos-11>".
        WHEN "#lit-var-espec-pedidos-12" THEN ASSIGN p-valor-literal = "<valor do label da vari vel #lit-var-espec-pedidos-12>".
        WHEN "#lit-var-espec-pedidos-13" THEN ASSIGN p-valor-literal = "<valor do label da vari vel #lit-var-espec-pedidos-13>".
        WHEN "#lit-var-espec-pedidos-14" THEN ASSIGN p-valor-literal = "<valor do label da vari vel #lit-var-espec-pedidos-14>".
        WHEN "#lit-var-espec-pedidos-15" THEN ASSIGN p-valor-literal = "<valor do label da vari vel #lit-var-espec-pedidos-15>".
        WHEN "#lit-var-espec-pedidos-16" THEN ASSIGN p-valor-literal = "<valor do label da vari vel #lit-var-espec-pedidos-16>".
        WHEN "#lit-var-espec-pedidos-17" THEN ASSIGN p-valor-literal = "<valor do label da vari vel #lit-var-espec-pedidos-17>".
        WHEN "#lit-var-espec-pedidos-18" THEN ASSIGN p-valor-literal = "<valor do label da vari vel #lit-var-espec-pedidos-18>".
        WHEN "#lit-var-espec-pedidos-19" THEN ASSIGN p-valor-literal = "<valor do label da vari vel #lit-var-espec-pedidos-19>".
        WHEN "#lit-var-espec-pedidos-20" THEN ASSIGN p-valor-literal = "<valor do label da vari vel #lit-var-espec-pedidos-20>".

        WHEN "#lit-var-espec-valores-inv-1"  THEN ASSIGN p-valor-literal = "<valor do label da vari vel #lit-var-espec-valores-inv-1>".
        WHEN "#lit-var-espec-valores-inv-2"  THEN ASSIGN p-valor-literal = "<valor do label da vari vel #lit-var-espec-valores-inv-2>".
        WHEN "#lit-var-espec-valores-inv-3"  THEN ASSIGN p-valor-literal = "<valor do label da vari vel #lit-var-espec-valores-inv-3>".
        WHEN "#lit-var-espec-valores-inv-4"  THEN ASSIGN p-valor-literal = "<valor do label da vari vel #lit-var-espec-valores-inv-4>".
        WHEN "#lit-var-espec-valores-inv-5"  THEN ASSIGN p-valor-literal = "<valor do label da vari vel #lit-var-espec-valores-inv-5>".
        WHEN "#lit-var-espec-valores-inv-6"  THEN ASSIGN p-valor-literal = "<valor do label da vari vel #lit-var-espec-valores-inv-6>".
        WHEN "#lit-var-espec-valores-inv-7"  THEN ASSIGN p-valor-literal = "<valor do label da vari vel #lit-var-espec-valores-inv-7>".
        WHEN "#lit-var-espec-valores-inv-8"  THEN ASSIGN p-valor-literal = "<valor do label da vari vel #lit-var-espec-valores-inv-8>".
        WHEN "#lit-var-espec-valores-inv-9"  THEN ASSIGN p-valor-literal = "<valor do label da vari vel #lit-var-espec-valores-inv-9>".
        WHEN "#lit-var-espec-valores-inv-10" THEN ASSIGN p-valor-literal = "<valor do label da vari vel #lit-var-espec-valores-inv-10>".
        WHEN "#lit-var-espec-valores-inv-11" THEN ASSIGN p-valor-literal = "<valor do label da vari vel #lit-var-espec-valores-inv-11>".
        WHEN "#lit-var-espec-valores-inv-12" THEN ASSIGN p-valor-literal = "<valor do label da vari vel #lit-var-espec-valores-inv-12>".
        WHEN "#lit-var-espec-valores-inv-13" THEN ASSIGN p-valor-literal = "<valor do label da vari vel #lit-var-espec-valores-inv-13>".
        WHEN "#lit-var-espec-valores-inv-14" THEN ASSIGN p-valor-literal = "<valor do label da vari vel #lit-var-espec-valores-inv-14>".
        WHEN "#lit-var-espec-valores-inv-15" THEN ASSIGN p-valor-literal = "<valor do label da vari vel #lit-var-espec-valores-inv-15>".
        WHEN "#lit-var-espec-valores-inv-16" THEN ASSIGN p-valor-literal = "<valor do label da vari vel #lit-var-espec-valores-inv-16>".
        WHEN "#lit-var-espec-valores-inv-17" THEN ASSIGN p-valor-literal = "<valor do label da vari vel #lit-var-espec-valores-inv-17>".
        WHEN "#lit-var-espec-valores-inv-18" THEN ASSIGN p-valor-literal = "<valor do label da vari vel #lit-var-espec-valores-inv-18>".
        WHEN "#lit-var-espec-valores-inv-19" THEN ASSIGN p-valor-literal = "<valor do label da vari vel #lit-var-espec-valores-inv-19>".
        WHEN "#lit-var-espec-valores-inv-20" THEN ASSIGN p-valor-literal = "<valor do label da vari vel #lit-var-espec-valores-inv-20>".

        WHEN "#lit-var-espec-valores-emb-1"  THEN ASSIGN p-valor-literal = "<valor do label da vari vel #lit-var-espec-valores-emb-1>".
        WHEN "#lit-var-espec-valores-emb-2"  THEN ASSIGN p-valor-literal = "<valor do label da vari vel #lit-var-espec-valores-emb-2>".
        WHEN "#lit-var-espec-valores-emb-3"  THEN ASSIGN p-valor-literal = "<valor do label da vari vel #lit-var-espec-valores-emb-3>".
        WHEN "#lit-var-espec-valores-emb-4"  THEN ASSIGN p-valor-literal = "<valor do label da vari vel #lit-var-espec-valores-emb-4>".
        WHEN "#lit-var-espec-valores-emb-5"  THEN ASSIGN p-valor-literal = "<valor do label da vari vel #lit-var-espec-valores-emb-5>".
        WHEN "#lit-var-espec-valores-emb-6"  THEN ASSIGN p-valor-literal = "<valor do label da vari vel #lit-var-espec-valores-emb-6>".
        WHEN "#lit-var-espec-valores-emb-7"  THEN ASSIGN p-valor-literal = "<valor do label da vari vel #lit-var-espec-valores-emb-7>".
        WHEN "#lit-var-espec-valores-emb-8"  THEN ASSIGN p-valor-literal = "<valor do label da vari vel #lit-var-espec-valores-emb-8>".
        WHEN "#lit-var-espec-valores-emb-9"  THEN ASSIGN p-valor-literal = "<valor do label da vari vel #lit-var-espec-valores-emb-9>".
        WHEN "#lit-var-espec-valores-emb-10" THEN ASSIGN p-valor-literal = "<valor do label da vari vel #lit-var-espec-valores-emb-10>".
        WHEN "#lit-var-espec-valores-emb-11" THEN ASSIGN p-valor-literal = "<valor do label da vari vel #lit-var-espec-valores-emb-11>".
        WHEN "#lit-var-espec-valores-emb-12" THEN ASSIGN p-valor-literal = "<valor do label da vari vel #lit-var-espec-valores-emb-12>".
        WHEN "#lit-var-espec-valores-emb-13" THEN ASSIGN p-valor-literal = "<valor do label da vari vel #lit-var-espec-valores-emb-13>".
        WHEN "#lit-var-espec-valores-emb-14" THEN ASSIGN p-valor-literal = "<valor do label da vari vel #lit-var-espec-valores-emb-14>".
        WHEN "#lit-var-espec-valores-emb-15" THEN ASSIGN p-valor-literal = "<valor do label da vari vel #lit-var-espec-valores-emb-15>".
        WHEN "#lit-var-espec-valores-emb-16" THEN ASSIGN p-valor-literal = "<valor do label da vari vel #lit-var-espec-valores-emb-16>".
        WHEN "#lit-var-espec-valores-emb-17" THEN ASSIGN p-valor-literal = "<valor do label da vari vel #lit-var-espec-valores-emb-17>".
        WHEN "#lit-var-espec-valores-emb-18" THEN ASSIGN p-valor-literal = "<valor do label da vari vel #lit-var-espec-valores-emb-18>".
        WHEN "#lit-var-espec-valores-emb-19" THEN ASSIGN p-valor-literal = "<valor do label da vari vel #lit-var-espec-valores-emb-19>".
        WHEN "#lit-var-espec-valores-emb-20" THEN ASSIGN p-valor-literal = "<valor do label da vari vel #lit-var-espec-valores-emb-20>".

        WHEN "#lit-var-espec-depos-1"  THEN ASSIGN p-valor-literal = "<valor do label da vari vel #lit-var-espec-depos-1>".
        WHEN "#lit-var-espec-depos-2"  THEN ASSIGN p-valor-literal = "<valor do label da vari vel #lit-var-espec-depos-2>".
        WHEN "#lit-var-espec-depos-3"  THEN ASSIGN p-valor-literal = "<valor do label da vari vel #lit-var-espec-depos-3>".
        WHEN "#lit-var-espec-depos-4"  THEN ASSIGN p-valor-literal = "<valor do label da vari vel #lit-var-espec-depos-4>".
        WHEN "#lit-var-espec-depos-5"  THEN ASSIGN p-valor-literal = "<valor do label da vari vel #lit-var-espec-depos-5>".
        WHEN "#lit-var-espec-depos-6"  THEN ASSIGN p-valor-literal = "<valor do label da vari vel #lit-var-espec-depos-6>".
        WHEN "#lit-var-espec-depos-7"  THEN ASSIGN p-valor-literal = "<valor do label da vari vel #lit-var-espec-depos-7>".
        WHEN "#lit-var-espec-depos-8"  THEN ASSIGN p-valor-literal = "<valor do label da vari vel #lit-var-espec-depos-8>".
        WHEN "#lit-var-espec-depos-9"  THEN ASSIGN p-valor-literal = "<valor do label da vari vel #lit-var-espec-depos-9>".
        WHEN "#lit-var-espec-depos-10" THEN ASSIGN p-valor-literal = "<valor do label da vari vel #lit-var-espec-depos-10>".
        WHEN "#lit-var-espec-depos-11" THEN ASSIGN p-valor-literal = "<valor do label da vari vel #lit-var-espec-depos-11>".
        WHEN "#lit-var-espec-depos-12" THEN ASSIGN p-valor-literal = "<valor do label da vari vel #lit-var-espec-depos-12>".
        WHEN "#lit-var-espec-depos-13" THEN ASSIGN p-valor-literal = "<valor do label da vari vel #lit-var-espec-depos-13>".
        WHEN "#lit-var-espec-depos-14" THEN ASSIGN p-valor-literal = "<valor do label da vari vel #lit-var-espec-depos-14>".
        WHEN "#lit-var-espec-depos-15" THEN ASSIGN p-valor-literal = "<valor do label da vari vel #lit-var-espec-depos-15>".
        WHEN "#lit-var-espec-depos-16" THEN ASSIGN p-valor-literal = "<valor do label da vari vel #lit-var-espec-depos-16>".
        WHEN "#lit-var-espec-depos-17" THEN ASSIGN p-valor-literal = "<valor do label da vari vel #lit-var-espec-depos-17>".
        WHEN "#lit-var-espec-depos-18" THEN ASSIGN p-valor-literal = "<valor do label da vari vel #lit-var-espec-depos-18>".
        WHEN "#lit-var-espec-depos-19" THEN ASSIGN p-valor-literal = "<valor do label da vari vel #lit-var-espec-depos-19>".
        WHEN "#lit-var-espec-depos-20" THEN ASSIGN p-valor-literal = "<valor do label da vari vel #lit-var-espec-depos-20>".

        WHEN "#lit-var-espec-doctos-inv-1"  THEN ASSIGN p-valor-literal = "<valor do label da vari vel #lit-var-espec-doctos-inv-1>".
        WHEN "#lit-var-espec-doctos-inv-2"  THEN ASSIGN p-valor-literal = "<valor do label da vari vel #lit-var-espec-doctos-inv-2>".
        WHEN "#lit-var-espec-doctos-inv-3"  THEN ASSIGN p-valor-literal = "<valor do label da vari vel #lit-var-espec-doctos-inv-3>".
        WHEN "#lit-var-espec-doctos-inv-4"  THEN ASSIGN p-valor-literal = "<valor do label da vari vel #lit-var-espec-doctos-inv-4>".
        WHEN "#lit-var-espec-doctos-inv-5"  THEN ASSIGN p-valor-literal = "<valor do label da vari vel #lit-var-espec-doctos-inv-5>".
        WHEN "#lit-var-espec-doctos-inv-6"  THEN ASSIGN p-valor-literal = "<valor do label da vari vel #lit-var-espec-doctos-inv-6>".
        WHEN "#lit-var-espec-doctos-inv-7"  THEN ASSIGN p-valor-literal = "<valor do label da vari vel #lit-var-espec-doctos-inv-7>".
        WHEN "#lit-var-espec-doctos-inv-8"  THEN ASSIGN p-valor-literal = "<valor do label da vari vel #lit-var-espec-doctos-inv-8>".
        WHEN "#lit-var-espec-doctos-inv-9"  THEN ASSIGN p-valor-literal = "<valor do label da vari vel #lit-var-espec-doctos-inv-9>".
        WHEN "#lit-var-espec-doctos-inv-10" THEN ASSIGN p-valor-literal = "<valor do label da vari vel #lit-var-espec-doctos-inv-10>".
        WHEN "#lit-var-espec-doctos-inv-11" THEN ASSIGN p-valor-literal = "<valor do label da vari vel #lit-var-espec-doctos-inv-11>".
        WHEN "#lit-var-espec-doctos-inv-12" THEN ASSIGN p-valor-literal = "<valor do label da vari vel #lit-var-espec-doctos-inv-12>".
        WHEN "#lit-var-espec-doctos-inv-13" THEN ASSIGN p-valor-literal = "<valor do label da vari vel #lit-var-espec-doctos-inv-13>".
        WHEN "#lit-var-espec-doctos-inv-14" THEN ASSIGN p-valor-literal = "<valor do label da vari vel #lit-var-espec-doctos-inv-14>".
        WHEN "#lit-var-espec-doctos-inv-15" THEN ASSIGN p-valor-literal = "<valor do label da vari vel #lit-var-espec-doctos-inv-15>".
        WHEN "#lit-var-espec-doctos-inv-16" THEN ASSIGN p-valor-literal = "<valor do label da vari vel #lit-var-espec-doctos-inv-16>".
        WHEN "#lit-var-espec-doctos-inv-17" THEN ASSIGN p-valor-literal = "<valor do label da vari vel #lit-var-espec-doctos-inv-17>".
        WHEN "#lit-var-espec-doctos-inv-18" THEN ASSIGN p-valor-literal = "<valor do label da vari vel #lit-var-espec-doctos-inv-18>".
        WHEN "#lit-var-espec-doctos-inv-19" THEN ASSIGN p-valor-literal = "<valor do label da vari vel #lit-var-espec-doctos-inv-19>".
        WHEN "#lit-var-espec-doctos-inv-20" THEN ASSIGN p-valor-literal = "<valor do label da vari vel #lit-var-espec-doctos-inv-20>".
        
        WHEN "#lit-var-espec-doctos-emb-1"  THEN ASSIGN p-valor-literal = "<valor do label da vari vel #lit-var-espec-doctos-emb-1>".
        WHEN "#lit-var-espec-doctos-emb-2"  THEN ASSIGN p-valor-literal = "<valor do label da vari vel #lit-var-espec-doctos-emb-2>".
        WHEN "#lit-var-espec-doctos-emb-3"  THEN ASSIGN p-valor-literal = "<valor do label da vari vel #lit-var-espec-doctos-emb-3>".
        WHEN "#lit-var-espec-doctos-emb-4"  THEN ASSIGN p-valor-literal = "<valor do label da vari vel #lit-var-espec-doctos-emb-4>".
        WHEN "#lit-var-espec-doctos-emb-5"  THEN ASSIGN p-valor-literal = "<valor do label da vari vel #lit-var-espec-doctos-emb-5>".
        WHEN "#lit-var-espec-doctos-emb-6"  THEN ASSIGN p-valor-literal = "<valor do label da vari vel #lit-var-espec-doctos-emb-6>".
        WHEN "#lit-var-espec-doctos-emb-7"  THEN ASSIGN p-valor-literal = "<valor do label da vari vel #lit-var-espec-doctos-emb-7>".
        WHEN "#lit-var-espec-doctos-emb-8"  THEN ASSIGN p-valor-literal = "<valor do label da vari vel #lit-var-espec-doctos-emb-8>".
        WHEN "#lit-var-espec-doctos-emb-9"  THEN ASSIGN p-valor-literal = "<valor do label da vari vel #lit-var-espec-doctos-emb-9>".
        WHEN "#lit-var-espec-doctos-emb-10" THEN ASSIGN p-valor-literal = "<valor do label da vari vel #lit-var-espec-doctos-emb-10>".
        WHEN "#lit-var-espec-doctos-emb-11" THEN ASSIGN p-valor-literal = "<valor do label da vari vel #lit-var-espec-doctos-emb-11>".
        WHEN "#lit-var-espec-doctos-emb-12" THEN ASSIGN p-valor-literal = "<valor do label da vari vel #lit-var-espec-doctos-emb-12>".
        WHEN "#lit-var-espec-doctos-emb-13" THEN ASSIGN p-valor-literal = "<valor do label da vari vel #lit-var-espec-doctos-emb-13>".
        WHEN "#lit-var-espec-doctos-emb-14" THEN ASSIGN p-valor-literal = "<valor do label da vari vel #lit-var-espec-doctos-emb-14>".
        WHEN "#lit-var-espec-doctos-emb-15" THEN ASSIGN p-valor-literal = "<valor do label da vari vel #lit-var-espec-doctos-emb-15>".
        WHEN "#lit-var-espec-doctos-emb-16" THEN ASSIGN p-valor-literal = "<valor do label da vari vel #lit-var-espec-doctos-emb-16>".
        WHEN "#lit-var-espec-doctos-emb-17" THEN ASSIGN p-valor-literal = "<valor do label da vari vel #lit-var-espec-doctos-emb-17>".
        WHEN "#lit-var-espec-doctos-emb-18" THEN ASSIGN p-valor-literal = "<valor do label da vari vel #lit-var-espec-doctos-emb-18>".
        WHEN "#lit-var-espec-doctos-emb-19" THEN ASSIGN p-valor-literal = "<valor do label da vari vel #lit-var-espec-doctos-emb-19>".
        WHEN "#lit-var-espec-doctos-emb-20" THEN ASSIGN p-valor-literal = "<valor do label da vari vel #lit-var-espec-doctos-emb-20>".

        WHEN "#lit-var-espec-invoice-1"  THEN ASSIGN p-valor-literal = "<valor do label da vari vel #lit-var-espec-invoice-1>".
        WHEN "#lit-var-espec-invoice-2"  THEN ASSIGN p-valor-literal = "<valor do label da vari vel #lit-var-espec-invoice-2>".
        WHEN "#lit-var-espec-invoice-3"  THEN ASSIGN p-valor-literal = "<valor do label da vari vel #lit-var-espec-invoice-3>".
        WHEN "#lit-var-espec-invoice-4"  THEN ASSIGN p-valor-literal = "<valor do label da vari vel #lit-var-espec-invoice-4>".
        WHEN "#lit-var-espec-invoice-5"  THEN ASSIGN p-valor-literal = "<valor do label da vari vel #lit-var-espec-invoice-5>".
        WHEN "#lit-var-espec-invoice-6"  THEN ASSIGN p-valor-literal = "<valor do label da vari vel #lit-var-espec-invoice-6>".
        WHEN "#lit-var-espec-invoice-7"  THEN ASSIGN p-valor-literal = "<valor do label da vari vel #lit-var-espec-invoice-7>".
        WHEN "#lit-var-espec-invoice-8"  THEN ASSIGN p-valor-literal = "<valor do label da vari vel #lit-var-espec-invoice-8>".
        WHEN "#lit-var-espec-invoice-9"  THEN ASSIGN p-valor-literal = "<valor do label da vari vel #lit-var-espec-invoice-9>".
        WHEN "#lit-var-espec-invoice-10" THEN ASSIGN p-valor-literal = "<valor do label da vari vel #lit-var-espec-invoice-10>".
        WHEN "#lit-var-espec-invoice-11" THEN ASSIGN p-valor-literal = "<valor do label da vari vel #lit-var-espec-invoice-11>".
        WHEN "#lit-var-espec-invoice-12" THEN ASSIGN p-valor-literal = "<valor do label da vari vel #lit-var-espec-invoice-12>".
        WHEN "#lit-var-espec-invoice-13" THEN ASSIGN p-valor-literal = "<valor do label da vari vel #lit-var-espec-invoice-13>".
        WHEN "#lit-var-espec-invoice-14" THEN ASSIGN p-valor-literal = "<valor do label da vari vel #lit-var-espec-invoice-14>".
        WHEN "#lit-var-espec-invoice-15" THEN ASSIGN p-valor-literal = "<valor do label da vari vel #lit-var-espec-invoice-15>".
        WHEN "#lit-var-espec-invoice-16" THEN ASSIGN p-valor-literal = "<valor do label da vari vel #lit-var-espec-invoice-16>".
        WHEN "#lit-var-espec-invoice-17" THEN ASSIGN p-valor-literal = "<valor do label da vari vel #lit-var-espec-invoice-17>".
        WHEN "#lit-var-espec-invoice-18" THEN ASSIGN p-valor-literal = "<valor do label da vari vel #lit-var-espec-invoice-18>".
        WHEN "#lit-var-espec-invoice-19" THEN ASSIGN p-valor-literal = "<valor do label da vari vel #lit-var-espec-invoice-19>".
        WHEN "#lit-var-espec-invoice-20" THEN ASSIGN p-valor-literal = "<valor do label da vari vel #lit-var-espec-invoice-20>".

        WHEN "#lit-var-espec-cotacao-1"  THEN ASSIGN p-valor-literal = "<valor do label da vari vel #lit-var-espec-cotacao-1>".
        WHEN "#lit-var-espec-cotacao-2"  THEN ASSIGN p-valor-literal = "<valor do label da vari vel #lit-var-espec-cotacao-2>".
        WHEN "#lit-var-espec-cotacao-3"  THEN ASSIGN p-valor-literal = "<valor do label da vari vel #lit-var-espec-cotacao-3>".
        WHEN "#lit-var-espec-cotacao-4"  THEN ASSIGN p-valor-literal = "<valor do label da vari vel #lit-var-espec-cotacao-4>".
        WHEN "#lit-var-espec-cotacao-5"  THEN ASSIGN p-valor-literal = "<valor do label da vari vel #lit-var-espec-cotacao-5>".
        WHEN "#lit-var-espec-cotacao-6"  THEN ASSIGN p-valor-literal = "<valor do label da vari vel #lit-var-espec-cotacao-6>".
        WHEN "#lit-var-espec-cotacao-7"  THEN ASSIGN p-valor-literal = "<valor do label da vari vel #lit-var-espec-cotacao-7>".
        WHEN "#lit-var-espec-cotacao-8"  THEN ASSIGN p-valor-literal = "<valor do label da vari vel #lit-var-espec-cotacao-8>".
        WHEN "#lit-var-espec-cotacao-9"  THEN ASSIGN p-valor-literal = "<valor do label da vari vel #lit-var-espec-cotacao-9>".
        WHEN "#lit-var-espec-cotacao-10" THEN ASSIGN p-valor-literal = "<valor do label da vari vel #lit-var-espec-cotacao-10>".
        WHEN "#lit-var-espec-cotacao-11" THEN ASSIGN p-valor-literal = "<valor do label da vari vel #lit-var-espec-cotacao-11>".
        WHEN "#lit-var-espec-cotacao-12" THEN ASSIGN p-valor-literal = "<valor do label da vari vel #lit-var-espec-cotacao-12>".
        WHEN "#lit-var-espec-cotacao-13" THEN ASSIGN p-valor-literal = "<valor do label da vari vel #lit-var-espec-cotacao-13>".
        WHEN "#lit-var-espec-cotacao-14" THEN ASSIGN p-valor-literal = "<valor do label da vari vel #lit-var-espec-cotacao-14>".
        WHEN "#lit-var-espec-cotacao-15" THEN ASSIGN p-valor-literal = "<valor do label da vari vel #lit-var-espec-cotacao-15>".
        WHEN "#lit-var-espec-cotacao-16" THEN ASSIGN p-valor-literal = "<valor do label da vari vel #lit-var-espec-cotacao-16>".
        WHEN "#lit-var-espec-cotacao-17" THEN ASSIGN p-valor-literal = "<valor do label da vari vel #lit-var-espec-cotacao-17>".
        WHEN "#lit-var-espec-cotacao-18" THEN ASSIGN p-valor-literal = "<valor do label da vari vel #lit-var-espec-cotacao-18>".
        WHEN "#lit-var-espec-cotacao-19" THEN ASSIGN p-valor-literal = "<valor do label da vari vel #lit-var-espec-cotacao-19>".
        WHEN "#lit-var-espec-cotacao-20" THEN ASSIGN p-valor-literal = "<valor do label da vari vel #lit-var-espec-cotacao-20>".

    END CASE.

END PROCEDURE.
 
PROCEDURE CabecEspec:
/*------------------------------------------------------------------------------
  Objetivo:    Substitui‡Æo das vari veis espec¡ficos pelos valores desejados.
------------------------------------------------------------------------------*/

    DEFINE INPUT  PARAMETER p-rw-embarque-imp    AS ROWID      NO-UNDO.
    DEFINE INPUT  PARAMETER p-variavel           AS CHARACTER  NO-UNDO.
    DEFINE OUTPUT PARAMETER p-valor-variavel     AS CHARACTER  NO-UNDO.
 
    /*** EXEMPLO PARA UTILIZA€ÇO DO ROWID,                                         ***/
    /* FOR FIRST embarque-imp FIELDS(campos a serem utilizados na customiza‡Æo)      */
    /*     WHERE ROWID(embarque-imp) = p-rw-embarque-imp NO-LOCK:                    */
    /* END.                                                                          */
    /*** EXEMPLO PARA UTILIZA€ÇO DO ROWID,                                         ***/
    /* FOR FIRST invoice-emb-imp FIELDS(campos a serem utilizados na customiza‡Æo)   */
    /*     WHERE ROWID(invoice-emb-imp) = p-rw-invoice-emb-imp NO-LOCK:              */
    /* END.                                                                          */
 
    CASE p-variavel:
        WHEN "#var-espec-cabec-1"  THEN ASSIGN p-valor-variavel = "<valor da vari vel #var-espec-cabec-1>".
        WHEN "#var-espec-cabec-2"  THEN ASSIGN p-valor-variavel = "<valor da vari vel #var-espec-cabec-2>".
        WHEN "#var-espec-cabec-3"  THEN ASSIGN p-valor-variavel = "<valor da vari vel #var-espec-cabec-3>".
        WHEN "#var-espec-cabec-4"  THEN ASSIGN p-valor-variavel = "<valor da vari vel #var-espec-cabec-4>".
        WHEN "#var-espec-cabec-5"  THEN ASSIGN p-valor-variavel = "<valor da vari vel #var-espec-cabec-5>".
        WHEN "#var-espec-cabec-6"  THEN ASSIGN p-valor-variavel = "<valor da vari vel #var-espec-cabec-6>".
        WHEN "#var-espec-cabec-7"  THEN ASSIGN p-valor-variavel = "<valor da vari vel #var-espec-cabec-7>".
        WHEN "#var-espec-cabec-8"  THEN ASSIGN p-valor-variavel = "<valor da vari vel #var-espec-cabec-8>".
        WHEN "#var-espec-cabec-9"  THEN ASSIGN p-valor-variavel = "<valor da vari vel #var-espec-cabec-9>".
        WHEN "#var-espec-cabec-10" THEN ASSIGN p-valor-variavel = "<valor da vari vel #var-espec-cabec-10>".
        WHEN "#var-espec-cabec-11" THEN ASSIGN p-valor-variavel = "<valor da vari vel #var-espec-cabec-11>".
        WHEN "#var-espec-cabec-12" THEN ASSIGN p-valor-variavel = "<valor da vari vel #var-espec-cabec-12>".
        WHEN "#var-espec-cabec-13" THEN ASSIGN p-valor-variavel = "<valor da vari vel #var-espec-cabec-13>".
        WHEN "#var-espec-cabec-14" THEN ASSIGN p-valor-variavel = "<valor da vari vel #var-espec-cabec-14>".
        WHEN "#var-espec-cabec-15" THEN ASSIGN p-valor-variavel = "<valor da vari vel #var-espec-cabec-15>".
        WHEN "#var-espec-cabec-16" THEN ASSIGN p-valor-variavel = "<valor da vari vel #var-espec-cabec-16>".
        WHEN "#var-espec-cabec-17" THEN ASSIGN p-valor-variavel = "<valor da vari vel #var-espec-cabec-17>".
        WHEN "#var-espec-cabec-18" THEN ASSIGN p-valor-variavel = "<valor da vari vel #var-espec-cabec-18>".
        WHEN "#var-espec-cabec-19" THEN ASSIGN p-valor-variavel = "<valor da vari vel #var-espec-cabec-19>".
        WHEN "#var-espec-cabec-20" THEN ASSIGN p-valor-variavel = "<valor da vari vel #var-espec-cabec-20>".
    END CASE.
END PROCEDURE.

PROCEDURE PedidosEspec:
/*------------------------------------------------------------------------------
  Objetivo:    Substitui‡Æo das vari veis espec¡ficos pelos valores desejados.
------------------------------------------------------------------------------*/

    DEFINE INPUT  PARAMETER p-rw-embarque-imp    AS ROWID      NO-UNDO.
    DEFINE INPUT  PARAMETER p-variavel           AS CHARACTER  NO-UNDO.
    DEFINE OUTPUT PARAMETER p-valor-variavel     AS CHARACTER  NO-UNDO.
 
    /*** EXEMPLO PARA UTILIZA€ÇO DO ROWID,                                         ***/
    /* FOR FIRST embarque-imp FIELDS(campos a serem utilizados na customiza‡Æo)      */
    /*     WHERE ROWID(embarque-imp) = p-rw-embarque-imp NO-LOCK:                    */
    /* END.                                                                          */
    /*** EXEMPLO PARA UTILIZA€ÇO DO ROWID,                                         ***/
    /* FOR FIRST invoice-emb-imp FIELDS(campos a serem utilizados na customiza‡Æo)   */
    /*     WHERE ROWID(invoice-emb-imp) = p-rw-invoice-emb-imp NO-LOCK:              */
    /* END.                                                                          */
 
    CASE p-variavel:
        WHEN "#var-espec-pedidos-1"  THEN ASSIGN p-valor-variavel = "<valor da vari vel #var-espec-pedidos-1>".
        WHEN "#var-espec-pedidos-2"  THEN ASSIGN p-valor-variavel = "<valor da vari vel #var-espec-pedidos-2>".
        WHEN "#var-espec-pedidos-3"  THEN ASSIGN p-valor-variavel = "<valor da vari vel #var-espec-pedidos-3>".
        WHEN "#var-espec-pedidos-4"  THEN ASSIGN p-valor-variavel = "<valor da vari vel #var-espec-pedidos-4>".
        WHEN "#var-espec-pedidos-5"  THEN ASSIGN p-valor-variavel = "<valor da vari vel #var-espec-pedidos-5>".
        WHEN "#var-espec-pedidos-6"  THEN ASSIGN p-valor-variavel = "<valor da vari vel #var-espec-pedidos-6>".
        WHEN "#var-espec-pedidos-7"  THEN ASSIGN p-valor-variavel = "<valor da vari vel #var-espec-pedidos-7>".
        WHEN "#var-espec-pedidos-8"  THEN ASSIGN p-valor-variavel = "<valor da vari vel #var-espec-pedidos-8>".
        WHEN "#var-espec-pedidos-9"  THEN ASSIGN p-valor-variavel = "<valor da vari vel #var-espec-pedidos-9>".
        WHEN "#var-espec-pedidos-10" THEN ASSIGN p-valor-variavel = "<valor da vari vel #var-espec-pedidos-10>".
        WHEN "#var-espec-pedidos-11" THEN ASSIGN p-valor-variavel = "<valor da vari vel #var-espec-pedidos-11>".
        WHEN "#var-espec-pedidos-12" THEN ASSIGN p-valor-variavel = "<valor da vari vel #var-espec-pedidos-12>".
        WHEN "#var-espec-pedidos-13" THEN ASSIGN p-valor-variavel = "<valor da vari vel #var-espec-pedidos-13>".
        WHEN "#var-espec-pedidos-14" THEN ASSIGN p-valor-variavel = "<valor da vari vel #var-espec-pedidos-14>".
        WHEN "#var-espec-pedidos-15" THEN ASSIGN p-valor-variavel = "<valor da vari vel #var-espec-pedidos-15>".
        WHEN "#var-espec-pedidos-16" THEN ASSIGN p-valor-variavel = "<valor da vari vel #var-espec-pedidos-16>".
        WHEN "#var-espec-pedidos-17" THEN ASSIGN p-valor-variavel = "<valor da vari vel #var-espec-pedidos-17>".
        WHEN "#var-espec-pedidos-18" THEN ASSIGN p-valor-variavel = "<valor da vari vel #var-espec-pedidos-18>".
        WHEN "#var-espec-pedidos-19" THEN ASSIGN p-valor-variavel = "<valor da vari vel #var-espec-pedidos-19>".
        WHEN "#var-espec-pedidos-20" THEN ASSIGN p-valor-variavel = "<valor da vari vel #var-espec-pedidos-20>".
    END CASE.
END PROCEDURE.

PROCEDURE ValoresInvEspec:
/*------------------------------------------------------------------------------
  Objetivo:    Substitui‡Æo das vari veis espec¡ficos pelos valores desejados.
------------------------------------------------------------------------------*/

    DEFINE INPUT  PARAMETER p-rw-embarque-imp    AS ROWID      NO-UNDO.
    DEFINE INPUT  PARAMETER p-variavel           AS CHARACTER  NO-UNDO.
    DEFINE OUTPUT PARAMETER p-valor-variavel     AS CHARACTER  NO-UNDO.
 
    /*** EXEMPLO PARA UTILIZA€ÇO DO ROWID,                                         ***/
    /* FOR FIRST embarque-imp FIELDS(campos a serem utilizados na customiza‡Æo)      */
    /*     WHERE ROWID(embarque-imp) = p-rw-embarque-imp NO-LOCK:                    */
    /* END.                                                                          */
    /*** EXEMPLO PARA UTILIZA€ÇO DO ROWID,                                         ***/
    /* FOR FIRST invoice-emb-imp FIELDS(campos a serem utilizados na customiza‡Æo)   */
    /*     WHERE ROWID(invoice-emb-imp) = p-rw-invoice-emb-imp NO-LOCK:              */
    /* END.                                                                          */
 
    CASE p-variavel:
        WHEN "#var-espec-valores-inv-1"  THEN ASSIGN p-valor-variavel = "<valor da vari vel #var-espec-valores-inv-1>".
        WHEN "#var-espec-valores-inv-2"  THEN ASSIGN p-valor-variavel = "<valor da vari vel #var-espec-valores-inv-2>".
        WHEN "#var-espec-valores-inv-3"  THEN ASSIGN p-valor-variavel = "<valor da vari vel #var-espec-valores-inv-3>".
        WHEN "#var-espec-valores-inv-4"  THEN ASSIGN p-valor-variavel = "<valor da vari vel #var-espec-valores-inv-4>".
        WHEN "#var-espec-valores-inv-5"  THEN ASSIGN p-valor-variavel = "<valor da vari vel #var-espec-valores-inv-5>".
        WHEN "#var-espec-valores-inv-6"  THEN ASSIGN p-valor-variavel = "<valor da vari vel #var-espec-valores-inv-6>".
        WHEN "#var-espec-valores-inv-7"  THEN ASSIGN p-valor-variavel = "<valor da vari vel #var-espec-valores-inv-7>".
        WHEN "#var-espec-valores-inv-8"  THEN ASSIGN p-valor-variavel = "<valor da vari vel #var-espec-valores-inv-8>".
        WHEN "#var-espec-valores-inv-9"  THEN ASSIGN p-valor-variavel = "<valor da vari vel #var-espec-valores-inv-9>".
        WHEN "#var-espec-valores-inv-10" THEN ASSIGN p-valor-variavel = "<valor da vari vel #var-espec-valores-inv-10>".
        WHEN "#var-espec-valores-inv-11" THEN ASSIGN p-valor-variavel = "<valor da vari vel #var-espec-valores-inv-11>".
        WHEN "#var-espec-valores-inv-12" THEN ASSIGN p-valor-variavel = "<valor da vari vel #var-espec-valores-inv-12>".
        WHEN "#var-espec-valores-inv-13" THEN ASSIGN p-valor-variavel = "<valor da vari vel #var-espec-valores-inv-13>".
        WHEN "#var-espec-valores-inv-14" THEN ASSIGN p-valor-variavel = "<valor da vari vel #var-espec-valores-inv-14>".
        WHEN "#var-espec-valores-inv-15" THEN ASSIGN p-valor-variavel = "<valor da vari vel #var-espec-valores-inv-15>".
        WHEN "#var-espec-valores-inv-16" THEN ASSIGN p-valor-variavel = "<valor da vari vel #var-espec-valores-inv-16>".
        WHEN "#var-espec-valores-inv-17" THEN ASSIGN p-valor-variavel = "<valor da vari vel #var-espec-valores-inv-17>".
        WHEN "#var-espec-valores-inv-18" THEN ASSIGN p-valor-variavel = "<valor da vari vel #var-espec-valores-inv-18>".
        WHEN "#var-espec-valores-inv-19" THEN ASSIGN p-valor-variavel = "<valor da vari vel #var-espec-valores-inv-19>".
        WHEN "#var-espec-valores-inv-20" THEN ASSIGN p-valor-variavel = "<valor da vari vel #var-espec-valores-inv-20>".
    END CASE.
END PROCEDURE.

PROCEDURE ValoresEmbEspec:
/*------------------------------------------------------------------------------
  Objetivo:    Substitui‡Æo das vari veis espec¡ficos pelos valores desejados.
------------------------------------------------------------------------------*/

    DEFINE INPUT  PARAMETER p-rw-embarque-imp    AS ROWID      NO-UNDO.
    DEFINE INPUT  PARAMETER p-variavel           AS CHARACTER  NO-UNDO.
    DEFINE OUTPUT PARAMETER p-valor-variavel     AS CHARACTER  NO-UNDO.
 
    /*** EXEMPLO PARA UTILIZA€ÇO DO ROWID,                                         ***/
    /* FOR FIRST embarque-imp FIELDS(campos a serem utilizados na customiza‡Æo)      */
    /*     WHERE ROWID(embarque-imp) = p-rw-embarque-imp NO-LOCK:                    */
    /* END.                                                                          */
    /*** EXEMPLO PARA UTILIZA€ÇO DO ROWID,                                         ***/
    /* FOR FIRST invoice-emb-imp FIELDS(campos a serem utilizados na customiza‡Æo)   */
    /*     WHERE ROWID(invoice-emb-imp) = p-rw-invoice-emb-imp NO-LOCK:              */
    /* END.                                                                          */
 
    CASE p-variavel:
        WHEN "#var-espec-valores-emb-1"  THEN ASSIGN p-valor-variavel = "<valor da vari vel #var-espec-valores-emb-1>".
        WHEN "#var-espec-valores-emb-2"  THEN ASSIGN p-valor-variavel = "<valor da vari vel #var-espec-valores-emb-2>".
        WHEN "#var-espec-valores-emb-3"  THEN ASSIGN p-valor-variavel = "<valor da vari vel #var-espec-valores-emb-3>".
        WHEN "#var-espec-valores-emb-4"  THEN ASSIGN p-valor-variavel = "<valor da vari vel #var-espec-valores-emb-4>".
        WHEN "#var-espec-valores-emb-5"  THEN ASSIGN p-valor-variavel = "<valor da vari vel #var-espec-valores-emb-5>".
        WHEN "#var-espec-valores-emb-6"  THEN ASSIGN p-valor-variavel = "<valor da vari vel #var-espec-valores-emb-6>".
        WHEN "#var-espec-valores-emb-7"  THEN ASSIGN p-valor-variavel = "<valor da vari vel #var-espec-valores-emb-7>".
        WHEN "#var-espec-valores-emb-8"  THEN ASSIGN p-valor-variavel = "<valor da vari vel #var-espec-valores-emb-8>".
        WHEN "#var-espec-valores-emb-9"  THEN ASSIGN p-valor-variavel = "<valor da vari vel #var-espec-valores-emb-9>".
        WHEN "#var-espec-valores-emb-10" THEN ASSIGN p-valor-variavel = "<valor da vari vel #var-espec-valores-emb-10>".
        WHEN "#var-espec-valores-emb-11" THEN ASSIGN p-valor-variavel = "<valor da vari vel #var-espec-valores-emb-11>".
        WHEN "#var-espec-valores-emb-12" THEN ASSIGN p-valor-variavel = "<valor da vari vel #var-espec-valores-emb-12>".
        WHEN "#var-espec-valores-emb-13" THEN ASSIGN p-valor-variavel = "<valor da vari vel #var-espec-valores-emb-13>".
        WHEN "#var-espec-valores-emb-14" THEN ASSIGN p-valor-variavel = "<valor da vari vel #var-espec-valores-emb-14>".
        WHEN "#var-espec-valores-emb-15" THEN ASSIGN p-valor-variavel = "<valor da vari vel #var-espec-valores-emb-15>".
        WHEN "#var-espec-valores-emb-16" THEN ASSIGN p-valor-variavel = "<valor da vari vel #var-espec-valores-emb-16>".
        WHEN "#var-espec-valores-emb-17" THEN ASSIGN p-valor-variavel = "<valor da vari vel #var-espec-valores-emb-17>".
        WHEN "#var-espec-valores-emb-18" THEN ASSIGN p-valor-variavel = "<valor da vari vel #var-espec-valores-emb-18>".
        WHEN "#var-espec-valores-emb-19" THEN ASSIGN p-valor-variavel = "<valor da vari vel #var-espec-valores-emb-19>".
        WHEN "#var-espec-valores-emb-20" THEN ASSIGN p-valor-variavel = "<valor da vari vel #var-espec-valores-emb-20>".
    END CASE.
END PROCEDURE.

PROCEDURE DeposEspec:
/*------------------------------------------------------------------------------
  Objetivo:    Substitui‡Æo das vari veis espec¡ficos pelos valores desejados.
------------------------------------------------------------------------------*/

    DEFINE INPUT  PARAMETER p-rw-embarque-imp    AS ROWID      NO-UNDO.
    DEFINE INPUT  PARAMETER p-variavel           AS CHARACTER  NO-UNDO.
    DEFINE OUTPUT PARAMETER p-valor-variavel     AS CHARACTER  NO-UNDO.
 
    /*** EXEMPLO PARA UTILIZA€ÇO DO ROWID,                                         ***/
    /* FOR FIRST embarque-imp FIELDS(campos a serem utilizados na customiza‡Æo)      */
    /*     WHERE ROWID(embarque-imp) = p-rw-embarque-imp NO-LOCK:                    */
    /* END.                                                                          */
    /*** EXEMPLO PARA UTILIZA€ÇO DO ROWID,                                         ***/
    /* FOR FIRST invoice-emb-imp FIELDS(campos a serem utilizados na customiza‡Æo)   */
    /*     WHERE ROWID(invoice-emb-imp) = p-rw-invoice-emb-imp NO-LOCK:              */
    /* END.                                                                          */
 
    CASE p-variavel:
        WHEN "#var-espec-depos-1"  THEN ASSIGN p-valor-variavel = "<valor da vari vel #var-espec-depos-1>".
        WHEN "#var-espec-depos-2"  THEN ASSIGN p-valor-variavel = "<valor da vari vel #var-espec-depos-2>".
        WHEN "#var-espec-depos-3"  THEN ASSIGN p-valor-variavel = "<valor da vari vel #var-espec-depos-3>".
        WHEN "#var-espec-depos-4"  THEN ASSIGN p-valor-variavel = "<valor da vari vel #var-espec-depos-4>".
        WHEN "#var-espec-depos-5"  THEN ASSIGN p-valor-variavel = "<valor da vari vel #var-espec-depos-5>".
        WHEN "#var-espec-depos-6"  THEN ASSIGN p-valor-variavel = "<valor da vari vel #var-espec-depos-6>".
        WHEN "#var-espec-depos-7"  THEN ASSIGN p-valor-variavel = "<valor da vari vel #var-espec-depos-7>".
        WHEN "#var-espec-depos-8"  THEN ASSIGN p-valor-variavel = "<valor da vari vel #var-espec-depos-8>".
        WHEN "#var-espec-depos-9"  THEN ASSIGN p-valor-variavel = "<valor da vari vel #var-espec-depos-9>".
        WHEN "#var-espec-depos-10" THEN ASSIGN p-valor-variavel = "<valor da vari vel #var-espec-depos-10>".
        WHEN "#var-espec-depos-11" THEN ASSIGN p-valor-variavel = "<valor da vari vel #var-espec-depos-11>".
        WHEN "#var-espec-depos-12" THEN ASSIGN p-valor-variavel = "<valor da vari vel #var-espec-depos-12>".
        WHEN "#var-espec-depos-13" THEN ASSIGN p-valor-variavel = "<valor da vari vel #var-espec-depos-13>".
        WHEN "#var-espec-depos-14" THEN ASSIGN p-valor-variavel = "<valor da vari vel #var-espec-depos-14>".
        WHEN "#var-espec-depos-15" THEN ASSIGN p-valor-variavel = "<valor da vari vel #var-espec-depos-15>".
        WHEN "#var-espec-depos-16" THEN ASSIGN p-valor-variavel = "<valor da vari vel #var-espec-depos-16>".
        WHEN "#var-espec-depos-17" THEN ASSIGN p-valor-variavel = "<valor da vari vel #var-espec-depos-17>".
        WHEN "#var-espec-depos-18" THEN ASSIGN p-valor-variavel = "<valor da vari vel #var-espec-depos-18>".
        WHEN "#var-espec-depos-19" THEN ASSIGN p-valor-variavel = "<valor da vari vel #var-espec-depos-19>".
        WHEN "#var-espec-depos-20" THEN ASSIGN p-valor-variavel = "<valor da vari vel #var-espec-depos-20>".
    END CASE.
END PROCEDURE.

PROCEDURE DoctosInvEspec:
/*------------------------------------------------------------------------------
  Objetivo:    Substitui‡Æo das vari veis espec¡ficos pelos valores desejados.
------------------------------------------------------------------------------*/

    DEFINE INPUT  PARAMETER p-rw-embarque-imp    AS ROWID      NO-UNDO.
    DEFINE INPUT  PARAMETER p-variavel           AS CHARACTER  NO-UNDO.
    DEFINE OUTPUT PARAMETER p-valor-variavel     AS CHARACTER  NO-UNDO.
 
    /*** EXEMPLO PARA UTILIZA€ÇO DO ROWID,                                         ***/
    /* FOR FIRST embarque-imp FIELDS(campos a serem utilizados na customiza‡Æo)      */
    /*     WHERE ROWID(embarque-imp) = p-rw-embarque-imp NO-LOCK:                    */
    /* END.                                                                          */
    /*** EXEMPLO PARA UTILIZA€ÇO DO ROWID,                                         ***/
    /* FOR FIRST invoice-emb-imp FIELDS(campos a serem utilizados na customiza‡Æo)   */
    /*     WHERE ROWID(invoice-emb-imp) = p-rw-invoice-emb-imp NO-LOCK:              */
    /* END.                                                                          */
 
    CASE p-variavel:
        WHEN "#var-espec-doctos-inv-1"  THEN ASSIGN p-valor-variavel = "<valor da vari vel #var-espec-doctos-inv-1>".
        WHEN "#var-espec-doctos-inv-2"  THEN ASSIGN p-valor-variavel = "<valor da vari vel #var-espec-doctos-inv-2>".
        WHEN "#var-espec-doctos-inv-3"  THEN ASSIGN p-valor-variavel = "<valor da vari vel #var-espec-doctos-inv-3>".
        WHEN "#var-espec-doctos-inv-4"  THEN ASSIGN p-valor-variavel = "<valor da vari vel #var-espec-doctos-inv-4>".
        WHEN "#var-espec-doctos-inv-5"  THEN ASSIGN p-valor-variavel = "<valor da vari vel #var-espec-doctos-inv-5>".
        WHEN "#var-espec-doctos-inv-6"  THEN ASSIGN p-valor-variavel = "<valor da vari vel #var-espec-doctos-inv-6>".
        WHEN "#var-espec-doctos-inv-7"  THEN ASSIGN p-valor-variavel = "<valor da vari vel #var-espec-doctos-inv-7>".
        WHEN "#var-espec-doctos-inv-8"  THEN ASSIGN p-valor-variavel = "<valor da vari vel #var-espec-doctos-inv-8>".
        WHEN "#var-espec-doctos-inv-9"  THEN ASSIGN p-valor-variavel = "<valor da vari vel #var-espec-doctos-inv-9>".
        WHEN "#var-espec-doctos-inv-10" THEN ASSIGN p-valor-variavel = "<valor da vari vel #var-espec-doctos-inv-10>".
        WHEN "#var-espec-doctos-inv-11" THEN ASSIGN p-valor-variavel = "<valor da vari vel #var-espec-doctos-inv-11>".
        WHEN "#var-espec-doctos-inv-12" THEN ASSIGN p-valor-variavel = "<valor da vari vel #var-espec-doctos-inv-12>".
        WHEN "#var-espec-doctos-inv-13" THEN ASSIGN p-valor-variavel = "<valor da vari vel #var-espec-doctos-inv-13>".
        WHEN "#var-espec-doctos-inv-14" THEN ASSIGN p-valor-variavel = "<valor da vari vel #var-espec-doctos-inv-14>".
        WHEN "#var-espec-doctos-inv-15" THEN ASSIGN p-valor-variavel = "<valor da vari vel #var-espec-doctos-inv-15>".
        WHEN "#var-espec-doctos-inv-16" THEN ASSIGN p-valor-variavel = "<valor da vari vel #var-espec-doctos-inv-16>".
        WHEN "#var-espec-doctos-inv-17" THEN ASSIGN p-valor-variavel = "<valor da vari vel #var-espec-doctos-inv-17>".
        WHEN "#var-espec-doctos-inv-18" THEN ASSIGN p-valor-variavel = "<valor da vari vel #var-espec-doctos-inv-18>".
        WHEN "#var-espec-doctos-inv-19" THEN ASSIGN p-valor-variavel = "<valor da vari vel #var-espec-doctos-inv-19>".
        WHEN "#var-espec-doctos-inv-20" THEN ASSIGN p-valor-variavel = "<valor da vari vel #var-espec-doctos-inv-20>".
    END CASE.
END PROCEDURE.

PROCEDURE DoctosEmbEspec:
/*------------------------------------------------------------------------------
  Objetivo:    Substitui‡Æo das vari veis espec¡ficos pelos valores desejados.
------------------------------------------------------------------------------*/

    DEFINE INPUT  PARAMETER p-rw-embarque-imp    AS ROWID      NO-UNDO.
    DEFINE INPUT  PARAMETER p-variavel           AS CHARACTER  NO-UNDO.
    DEFINE OUTPUT PARAMETER p-valor-variavel     AS CHARACTER  NO-UNDO.
 
    /*** EXEMPLO PARA UTILIZA€ÇO DO ROWID,                                         ***/
    /* FOR FIRST embarque-imp FIELDS(campos a serem utilizados na customiza‡Æo)      */
    /*     WHERE ROWID(embarque-imp) = p-rw-embarque-imp NO-LOCK:                    */
    /* END.                                                                          */
    /*** EXEMPLO PARA UTILIZA€ÇO DO ROWID,                                         ***/
    /* FOR FIRST invoice-emb-imp FIELDS(campos a serem utilizados na customiza‡Æo)   */
    /*     WHERE ROWID(invoice-emb-imp) = p-rw-invoice-emb-imp NO-LOCK:              */
    /* END.                                                                          */
 
    CASE p-variavel:
        WHEN "#var-espec-doctos-emb-1"  THEN ASSIGN p-valor-variavel = "<valor da vari vel #var-espec-doctos-emb-1>".
        WHEN "#var-espec-doctos-emb-2"  THEN ASSIGN p-valor-variavel = "<valor da vari vel #var-espec-doctos-emb-2>".
        WHEN "#var-espec-doctos-emb-3"  THEN ASSIGN p-valor-variavel = "<valor da vari vel #var-espec-doctos-emb-3>".
        WHEN "#var-espec-doctos-emb-4"  THEN ASSIGN p-valor-variavel = "<valor da vari vel #var-espec-doctos-emb-4>".
        WHEN "#var-espec-doctos-emb-5"  THEN ASSIGN p-valor-variavel = "<valor da vari vel #var-espec-doctos-emb-5>".
        WHEN "#var-espec-doctos-emb-6"  THEN ASSIGN p-valor-variavel = "<valor da vari vel #var-espec-doctos-emb-6>".
        WHEN "#var-espec-doctos-emb-7"  THEN ASSIGN p-valor-variavel = "<valor da vari vel #var-espec-doctos-emb-7>".
        WHEN "#var-espec-doctos-emb-8"  THEN ASSIGN p-valor-variavel = "<valor da vari vel #var-espec-doctos-emb-8>".
        WHEN "#var-espec-doctos-emb-9"  THEN ASSIGN p-valor-variavel = "<valor da vari vel #var-espec-doctos-emb-9>".
        WHEN "#var-espec-doctos-emb-10" THEN ASSIGN p-valor-variavel = "<valor da vari vel #var-espec-doctos-emb-10>".
        WHEN "#var-espec-doctos-emb-11" THEN ASSIGN p-valor-variavel = "<valor da vari vel #var-espec-doctos-emb-11>".
        WHEN "#var-espec-doctos-emb-12" THEN ASSIGN p-valor-variavel = "<valor da vari vel #var-espec-doctos-emb-12>".
        WHEN "#var-espec-doctos-emb-13" THEN ASSIGN p-valor-variavel = "<valor da vari vel #var-espec-doctos-emb-13>".
        WHEN "#var-espec-doctos-emb-14" THEN ASSIGN p-valor-variavel = "<valor da vari vel #var-espec-doctos-emb-14>".
        WHEN "#var-espec-doctos-emb-15" THEN ASSIGN p-valor-variavel = "<valor da vari vel #var-espec-doctos-emb-15>".
        WHEN "#var-espec-doctos-emb-16" THEN ASSIGN p-valor-variavel = "<valor da vari vel #var-espec-doctos-emb-16>".
        WHEN "#var-espec-doctos-emb-17" THEN ASSIGN p-valor-variavel = "<valor da vari vel #var-espec-doctos-emb-17>".
        WHEN "#var-espec-doctos-emb-18" THEN ASSIGN p-valor-variavel = "<valor da vari vel #var-espec-doctos-emb-18>".
        WHEN "#var-espec-doctos-emb-19" THEN ASSIGN p-valor-variavel = "<valor da vari vel #var-espec-doctos-emb-19>".
        WHEN "#var-espec-doctos-emb-20" THEN ASSIGN p-valor-variavel = "<valor da vari vel #var-espec-doctos-emb-20>".
    END CASE.
END PROCEDURE.

PROCEDURE InvoiceEspec:
/*------------------------------------------------------------------------------
  Objetivo:    Substitui‡Æo das vari veis espec¡ficos pelos valores desejados.
------------------------------------------------------------------------------*/

    DEFINE INPUT  PARAMETER p-rw-embarque-imp    AS ROWID      NO-UNDO.
    DEFINE INPUT  PARAMETER p-variavel           AS CHARACTER  NO-UNDO.
    DEFINE OUTPUT PARAMETER p-valor-variavel     AS CHARACTER  NO-UNDO.
 
    /*** EXEMPLO PARA UTILIZA€ÇO DO ROWID,                                         ***/
    /* FOR FIRST embarque-imp FIELDS(campos a serem utilizados na customiza‡Æo)      */
    /*     WHERE ROWID(embarque-imp) = p-rw-embarque-imp NO-LOCK:                    */
    /* END.                                                                          */
    /*** EXEMPLO PARA UTILIZA€ÇO DO ROWID,                                         ***/
    /* FOR FIRST invoice-emb-imp FIELDS(campos a serem utilizados na customiza‡Æo)   */
    /*     WHERE ROWID(invoice-emb-imp) = p-rw-invoice-emb-imp NO-LOCK:              */
    /* END.                                                                          */
 
    CASE p-variavel:
        WHEN "#var-espec-invoice-1"  THEN ASSIGN p-valor-variavel = "<valor da vari vel #var-espec-invoice-1>".
        WHEN "#var-espec-invoice-2"  THEN ASSIGN p-valor-variavel = "<valor da vari vel #var-espec-invoice-2>".
        WHEN "#var-espec-invoice-3"  THEN ASSIGN p-valor-variavel = "<valor da vari vel #var-espec-invoice-3>".
        WHEN "#var-espec-invoice-4"  THEN ASSIGN p-valor-variavel = "<valor da vari vel #var-espec-invoice-4>".
        WHEN "#var-espec-invoice-5"  THEN ASSIGN p-valor-variavel = "<valor da vari vel #var-espec-invoice-5>".
        WHEN "#var-espec-invoice-6"  THEN ASSIGN p-valor-variavel = "<valor da vari vel #var-espec-invoice-6>".
        WHEN "#var-espec-invoice-7"  THEN ASSIGN p-valor-variavel = "<valor da vari vel #var-espec-invoice-7>".
        WHEN "#var-espec-invoice-8"  THEN ASSIGN p-valor-variavel = "<valor da vari vel #var-espec-invoice-8>".
        WHEN "#var-espec-invoice-9"  THEN ASSIGN p-valor-variavel = "<valor da vari vel #var-espec-invoice-9>".
        WHEN "#var-espec-invoice-10" THEN ASSIGN p-valor-variavel = "<valor da vari vel #var-espec-invoice-10>".
        WHEN "#var-espec-invoice-11" THEN ASSIGN p-valor-variavel = "<valor da vari vel #var-espec-invoice-11>".
        WHEN "#var-espec-invoice-12" THEN ASSIGN p-valor-variavel = "<valor da vari vel #var-espec-invoice-12>".
        WHEN "#var-espec-invoice-13" THEN ASSIGN p-valor-variavel = "<valor da vari vel #var-espec-invoice-13>".
        WHEN "#var-espec-invoice-14" THEN ASSIGN p-valor-variavel = "<valor da vari vel #var-espec-invoice-14>".
        WHEN "#var-espec-invoice-15" THEN ASSIGN p-valor-variavel = "<valor da vari vel #var-espec-invoice-15>".
        WHEN "#var-espec-invoice-16" THEN ASSIGN p-valor-variavel = "<valor da vari vel #var-espec-invoice-16>".
        WHEN "#var-espec-invoice-17" THEN ASSIGN p-valor-variavel = "<valor da vari vel #var-espec-invoice-17>".
        WHEN "#var-espec-invoice-18" THEN ASSIGN p-valor-variavel = "<valor da vari vel #var-espec-invoice-18>".
        WHEN "#var-espec-invoice-19" THEN ASSIGN p-valor-variavel = "<valor da vari vel #var-espec-invoice-19>".
        WHEN "#var-espec-invoice-20" THEN ASSIGN p-valor-variavel = "<valor da vari vel #var-espec-invoice-20>".
    END CASE.
END PROCEDURE.

PROCEDURE CotacaoEspec:
/*------------------------------------------------------------------------------
  Objetivo:    Substitui‡Æo das vari veis espec¡ficos pelos valores desejados.
------------------------------------------------------------------------------*/

    DEFINE INPUT  PARAMETER p-rw-embarque-imp    AS ROWID      NO-UNDO.
    DEFINE INPUT  PARAMETER p-variavel           AS CHARACTER  NO-UNDO.
    DEFINE OUTPUT PARAMETER p-valor-variavel     AS CHARACTER  NO-UNDO.
 
    /*** EXEMPLO PARA UTILIZA€ÇO DO ROWID,                                         ***/
    /* FOR FIRST embarque-imp FIELDS(campos a serem utilizados na customiza‡Æo)      */
    /*     WHERE ROWID(embarque-imp) = p-rw-embarque-imp NO-LOCK:                    */
    /* END.                                                                          */
    /*** EXEMPLO PARA UTILIZA€ÇO DO ROWID,                                         ***/
    /* FOR FIRST invoice-emb-imp FIELDS(campos a serem utilizados na customiza‡Æo)   */
    /*     WHERE ROWID(invoice-emb-imp) = p-rw-invoice-emb-imp NO-LOCK:              */
    /* END.                                                                          */
 
    CASE p-variavel:
        WHEN "#var-espec-cotacao-1"  THEN ASSIGN p-valor-variavel = "<valor da vari vel #var-espec-cotacao-1>".
        WHEN "#var-espec-cotacao-2"  THEN ASSIGN p-valor-variavel = "<valor da vari vel #var-espec-cotacao-2>".
        WHEN "#var-espec-cotacao-3"  THEN ASSIGN p-valor-variavel = "<valor da vari vel #var-espec-cotacao-3>".
        WHEN "#var-espec-cotacao-4"  THEN ASSIGN p-valor-variavel = "<valor da vari vel #var-espec-cotacao-4>".
        WHEN "#var-espec-cotacao-5"  THEN ASSIGN p-valor-variavel = "<valor da vari vel #var-espec-cotacao-5>".
        WHEN "#var-espec-cotacao-6"  THEN ASSIGN p-valor-variavel = "<valor da vari vel #var-espec-cotacao-6>".
        WHEN "#var-espec-cotacao-7"  THEN ASSIGN p-valor-variavel = "<valor da vari vel #var-espec-cotacao-7>".
        WHEN "#var-espec-cotacao-8"  THEN ASSIGN p-valor-variavel = "<valor da vari vel #var-espec-cotacao-8>".
        WHEN "#var-espec-cotacao-9"  THEN ASSIGN p-valor-variavel = "<valor da vari vel #var-espec-cotacao-9>".
        WHEN "#var-espec-cotacao-10" THEN ASSIGN p-valor-variavel = "<valor da vari vel #var-espec-cotacao-10>".
        WHEN "#var-espec-cotacao-11" THEN ASSIGN p-valor-variavel = "<valor da vari vel #var-espec-cotacao-11>".
        WHEN "#var-espec-cotacao-12" THEN ASSIGN p-valor-variavel = "<valor da vari vel #var-espec-cotacao-12>".
        WHEN "#var-espec-cotacao-13" THEN ASSIGN p-valor-variavel = "<valor da vari vel #var-espec-cotacao-13>".
        WHEN "#var-espec-cotacao-14" THEN ASSIGN p-valor-variavel = "<valor da vari vel #var-espec-cotacao-14>".
        WHEN "#var-espec-cotacao-15" THEN ASSIGN p-valor-variavel = "<valor da vari vel #var-espec-cotacao-15>".
        WHEN "#var-espec-cotacao-16" THEN ASSIGN p-valor-variavel = "<valor da vari vel #var-espec-cotacao-16>".
        WHEN "#var-espec-cotacao-17" THEN ASSIGN p-valor-variavel = "<valor da vari vel #var-espec-cotacao-17>".
        WHEN "#var-espec-cotacao-18" THEN ASSIGN p-valor-variavel = "<valor da vari vel #var-espec-cotacao-18>".
        WHEN "#var-espec-cotacao-19" THEN ASSIGN p-valor-variavel = "<valor da vari vel #var-espec-cotacao-19>".
        WHEN "#var-espec-cotacao-20" THEN ASSIGN p-valor-variavel = "<valor da vari vel #var-espec-cotacao-20>".
    END CASE.
END PROCEDURE.

 

