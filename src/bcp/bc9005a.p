/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC9005A 2.00.00.010 } /*** 010010 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i bc9005a MBC}
&ENDIF


/********************************************************************************************
**   Programa..: bc9005a.p                                                                 **
**                                                                                         **
**   Versao....: 2.00.00.000 - dez/2006 - Amarildo Gambeta                                 **
**                                                                                         **
**   Objetivo..: Teste para o programa de Transferencia de Materiais (bcp/bc9005.p)        **
**                                                                                         **
********************************************************************************************/

/********************  Frame Fields Preprocessor Definitions Beg  ***************/
&GLOBAL-DEFINE FrameFields  tt-transfere-bc.cod-estabel ~
                            tt-transfere-bc.num-documento ~
                            tt-transfere-bc.cod-serie-documento ~
                            tt-transfere-bc.num-especie-documento ~
                            tt-transfere-bc.data-transacao ~
                            tt-transfere-bc.cod-item ~
                            tt-transfere-bc.cod-unico ~
                            tt-transfere-bc.cod-refer-origem ~
                            tt-transfere-bc.cod-refer-destino ~
                            tt-transfere-bc.cod-depos-origem ~
                            tt-transfere-bc.cod-depos-destino ~
                            tt-transfere-bc.cod-local-origem ~
                            tt-transfere-bc.cod-local-destino ~
                            tt-transfere-bc.cod-lote-origem ~
                            tt-transfere-bc.cod-lote-destino ~
                            tt-transfere-bc.dat-valid-lote-origem ~
                            tt-transfere-bc.dat-valid-lote-destino ~
                            tt-transfere-bc.cod-usuario ~
                            tt-transfere-bc.qtd-movimento ~
                            tt-transfere-bc.ct-codigo ~
                            tt-transfere-bc.sc-codigo ~
                            tt-transfere-bc.num-sequencia ~
                            tt-transfere-bc.un ~
                            tt-transfere-bc.cod-livre-1 ~
                            tt-transfere-bc.cod-livre-2 ~
                            tt-transfere-bc.cod-livre-3 ~
                            tt-transfere-bc.num-livre-1 ~
                            tt-transfere-bc.num-livre-2 ~
                            tt-transfere-bc.num-livre-3 ~
                            tt-transfere-bc.dec-livre-1 ~
                            tt-transfere-bc.dec-livre-2 ~
                            tt-transfere-bc.dec-livre-3 ~
                            tt-transfere-bc.log-livre-1 ~
                            tt-transfere-bc.log-livre-2 ~
                            tt-transfere-bc.log-livre-3

/********************  Frame Fields Preprocessor Definitions End  ***************/


/*****************  Name of TT Include Preprocessor Definitions Beg  ************/
&GLOBAL-DEFINE NameOfTTInclude bcp/bc9005.i
/*****************  Name of TT Include Preprocessor Definitions End  ************/


/*******************  Program Title Preprocessor Definitions Beg  ***************/
&GLOBAL-DEFINE ProgramTitle Transferencia - bc9005a.p 2.00.00.000
/*******************  Program Title Preprocessor Definitions End  ***************/


/**************  Frame Number of Columns Preprocessor Definitions Beg  **********/
&GLOBAL-DEFINE FrameNumOfColumns 2
/**************  Frame Number of Columns Preprocessor Definitions End  **********/


/*****************  Geracao Etiquetas Preprocessor Definitions Beg  *************/
&GLOBAL-DEFINE TransactionProgram bc9005
/*****************  Geracao Etiquetas Preprocessor Definitions End  *************/


/**********************  Table Preprocessor Definitions Beg  ********************/
&GLOBAL-DEFINE Table tt-transfere-bc
/**********************  Table Preprocessor Definitions End  ********************/


/**********************  Table Preprocessor Definitions Beg  ********************/
&GLOBAL-DEFINE TransDetail vCodTransaction + ~
                           " Doc: "        + String({&Table}.num-documento)     + ~
                           " Item: "       + Trim(  {&Table}.cod-item)          + ~
                           " Ref: "        + Trim(  {&Table}.cod-refer-origem)  + ~
                           " Depos: "      + Trim(  {&Table}.cod-depos-destino) + ~
                           " Local: "      + Trim(  {&Table}.cod-local-destino) + ~
                           " Lote: "       + Trim(  {&Table}.cod-lote-destino)  + ~
                           " Qt: "         + String({&Table}.qtd-movimento)

/**********************  Table Preprocessor Definitions End  ********************/


/**************  Fields Custom Display Preprocessor Definitions Beg  ************/
/**************  Fields Custom Display Preprocessor Definitions End  ************/

/**************  Fields Custom Formats Preprocessor Definitions Beg  ************/

/**************  Fields Custom Formats Preprocessor Definitions End  ************/

{bcp/bc9106.i}
