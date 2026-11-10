/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC9051A 2.00.00.011 } /*** 010011 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i bc9051a MBC}
&ENDIF


/********************************************************************************************
**   Programa..: bc9051a.p                                                                 **
**                                                                                         **
**   Versao....: 2.00.00.000 - dez/2006 - Amarildo Gambeta                                 **
**                                                                                         **
**   Objetivo..: Teste para o programa de Transferencia de Materiais (bcp/bc9051.p)        **
**                                                                                         **
********************************************************************************************/

/********************  Frame Fields Preprocessor Definitions Beg  ***************/
&GLOBAL-DEFINE FrameFields  tt-transfere-prod-bc.nr-ord-produ ~
                            tt-transfere-prod-bc.it-codigo ~
                            tt-transfere-prod-bc.cod-refer ~
                            tt-transfere-prod-bc.lote-serie ~
                            tt-transfere-prod-bc.cod-depos-sai ~
                            tt-transfere-prod-bc.cod-localiz-sai ~
                            tt-transfere-prod-bc.cod-depos-ent ~
                            tt-transfere-prod-bc.cod-localiz-ent ~
                            tt-transfere-prod-bc.num-documento ~
                            tt-transfere-prod-bc.cod-serie-documento ~
                            tt-transfere-prod-bc.cod-usuario ~
                            tt-transfere-prod-bc.data-transacao ~
                            tt-transfere-prod-bc.quantidade

/********************  Frame Fields Preprocessor Definitions End  ***************/


/*****************  Name of TT Include Preprocessor Definitions Beg  ************/
&GLOBAL-DEFINE NameOfTTInclude bcp/bc9051.i
/*****************  Name of TT Include Preprocessor Definitions End  ************/


/*******************  Program Title Preprocessor Definitions Beg  ***************/
&GLOBAL-DEFINE ProgramTitle Transferencia - bc9051a.p 2.00.00.000
/*******************  Program Title Preprocessor Definitions End  ***************/


/**************  Frame Number of Columns Preprocessor Definitions Beg  **********/
&GLOBAL-DEFINE FrameNumOfColumns 2
/**************  Frame Number of Columns Preprocessor Definitions End  **********/


/*****************  Geracao Etiquetas Preprocessor Definitions Beg  *************/
&GLOBAL-DEFINE TransactionProgram bc9051
/*****************  Geracao Etiquetas Preprocessor Definitions End  *************/


/**********************  Table Preprocessor Definitions Beg  ********************/
&GLOBAL-DEFINE Table tt-transfere-prod-bc
/**********************  Table Preprocessor Definitions End  ********************/


/**********************  Table Preprocessor Definitions Beg  ********************/
&GLOBAL-DEFINE TransDetail vCodTransaction + ~
                          " Ordem: ":U       + Trim(STRING({&Table}.nr-ord-produ))   + ~
                          " Item: ":U        + Trim(STRING({&Table}.it-codigo))      + ~
                          " Depos Saida: ":U       + Trim({&Table}.cod-depos-sai)    + ~
                          " Local Saida: ":U       + Trim({&Table}.cod-localiz-sai)
                          
/**********************  Table Preprocessor Definitions End  ********************/


/**************  Fields Custom Display Preprocessor Definitions Beg  ************/
/**************  Fields Custom Display Preprocessor Definitions End  ************/

/**************  Fields Custom Formats Preprocessor Definitions Beg  ************/

/**************  Fields Custom Formats Preprocessor Definitions End  ************/

{bcp/bc9106.i}
