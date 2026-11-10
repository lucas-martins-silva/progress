/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC9002A 2.00.00.010 } /*** 010010 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i bc9002a MBC}
&ENDIF


/********************************************************************************************
**   Programa..: bc9002a.p                                                                 **
**                                                                                         **
**   Versao....: 2.00.00.000 - jun/2000 - John Cleber Jaraceski                            **
**                                                                                         **
**   Objetivo..: Teste para o programa de Reporte por Contagem Ciclica (bcp/bc9002.p)      **
**                                                                                         **
**   Includes..: bcp/bc9106.i                                                              **
**                                                                                         **
********************************************************************************************/

/********************  Frame Fields Preprocessor Definitions Beg  ***************/
&GLOBAL-DEFINE FrameFields  tt-contagem-bc.cod-estabel ~
                            tt-contagem-bc.num-ficha-inventario ~
                            tt-contagem-bc.num-contagem ~
                            tt-contagem-bc.data-transacao ~
                            tt-contagem-bc.dat-contagem ~
                            tt-contagem-bc.cod-item ~
                            tt-contagem-bc.cod-unico ~
                            tt-contagem-bc.cod-refer ~
                            tt-contagem-bc.cod-depos ~
                            tt-contagem-bc.cod-local ~
                            tt-contagem-bc.cod-lote ~
                            tt-contagem-bc.dat-valid-lote ~
                            tt-contagem-bc.cod-usuario ~
                            tt-contagem-bc.qtd-apontada ~
                            tt-contagem-bc.valor-mat-m ~
                            tt-contagem-bc.valor-mob-m ~
                            tt-contagem-bc.valor-mat-o ~
                            tt-contagem-bc.valor-mat-p ~
                            tt-contagem-bc.valor-mob-o ~
                            tt-contagem-bc.valor-mob-p ~
                            tt-contagem-bc.valor-ggf-m ~
                            tt-contagem-bc.valor-ggf-o ~
                            tt-contagem-bc.valor-ggf-p ~
                            tt-contagem-bc.cod-livre-1 ~
                            tt-contagem-bc.cod-livre-2 ~
                            tt-contagem-bc.cod-livre-3 ~
                            tt-contagem-bc.num-livre-1 ~
                            tt-contagem-bc.num-livre-2 ~
                            tt-contagem-bc.num-livre-3 ~
                            tt-contagem-bc.dec-livre-1 ~
                            tt-contagem-bc.dec-livre-2 ~
                            tt-contagem-bc.dec-livre-3 ~
                            tt-contagem-bc.log-livre-1 ~
                            tt-contagem-bc.log-livre-2 ~
                            tt-contagem-bc.log-livre-3

/********************  Frame Fields Preprocessor Definitions End  ***************/


/*****************  Name of TT Include Preprocessor Definitions Beg  ************/
&GLOBAL-DEFINE NameOfTTInclude bcp/bc9002.i
/*****************  Name of TT Include Preprocessor Definitions End  ************/


/*******************  Program Title Preprocessor Definitions Beg  ***************/
&GLOBAL-DEFINE ProgramTitle Contagem C¡clica - bc9002a.p 2.00.00.000
/*******************  Program Title Preprocessor Definitions End  ***************/
                           
                           
/**************  Frame Number of Columns Preprocessor Definitions Beg  **********/
&GLOBAL-DEFINE FrameNumOfColumns 2
/**************  Frame Number of Columns Preprocessor Definitions End  **********/


/*****************  Geracao Etiquetas Preprocessor Definitions Beg  *************/
&GLOBAL-DEFINE TransactionProgram bc9002
/*****************  Geracao Etiquetas Preprocessor Definitions End  *************/


/**********************  Table Preprocessor Definitions Beg  ********************/
&GLOBAL-DEFINE Table tt-contagem-bc
/**********************  Table Preprocessor Definitions End  ********************/


/**********************  Table Preprocessor Definitions Beg  ********************/
&GLOBAL-DEFINE TransDetail vCodTransaction + ~
                           " Doc: "        + String({&Table}.num-ficha-inventario) + ~
                           " Item: "       + Trim(  {&Table}.cod-item)             + ~
                           " Ref: "        + Trim(  {&Table}.cod-refer)            + ~
                           " Depos: "      + Trim(  {&Table}.cod-depos)            + ~
                           " Local: "      + Trim(  {&Table}.cod-local)            + ~
                           " Lote: "       + Trim(  {&Table}.cod-lote)             + ~
                           " Qt: "         + String({&Table}.qtd-apontada)

/**********************  Table Preprocessor Definitions End  ********************/


/**************  Fields Custom Display Preprocessor Definitions Beg  ************/
/**************  Fields Custom Display Preprocessor Definitions End  ************/

/**************  Fields Custom Formats Preprocessor Definitions Beg  ************/

/**************  Fields Custom Formats Preprocessor Definitions End  ************/

{bcp/bc9106.i}
