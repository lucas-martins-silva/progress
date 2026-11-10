/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC9003A 2.00.00.010 } /*** 010010 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i bc9003a MBC}
&ENDIF


/********************************************************************************************
**   Programa..: bc9003a.p                                                                 **
**                                                                                         **
**   Versao....: 2.00.00.000 - jun/2000 - John Cleber Jaraceski                            **
**                                                                                         **
**   Objetivo..: Teste para o programa de Reporte por Ordem (bcp/bc9003.p)                 **
**                                                                                         **
**   Includes..: bcp/bc9106.i                                                              **
**                                                                                         **
********************************************************************************************/


/********************  Frame Fields Preprocessor Definitions Beg  ***************/
&GLOBAL-DEFINE FrameFields  tt-reporte-ordem-bc.tipo ~
                            tt-reporte-ordem-bc.nr-ord-produ ~
                            tt-reporte-ordem-bc.data-transacao ~
                            tt-reporte-ordem-bc.data ~
                            tt-reporte-ordem-bc.qt-reporte ~
                            tt-reporte-ordem-bc.it-codigo ~
                            tt-reporte-ordem-bc.un ~
                            tt-reporte-ordem-bc.nro-docto ~
                            tt-reporte-ordem-bc.serie-docto ~
                            tt-reporte-ordem-bc.cod-depos-sai ~
                            tt-reporte-ordem-bc.cod-local-sai ~
                            tt-reporte-ordem-bc.cod-depos ~
                            tt-reporte-ordem-bc.cod-localiz ~
                            tt-reporte-ordem-bc.lote-serie ~
                            tt-reporte-ordem-bc.cod-refer ~
                            tt-reporte-ordem-bc.dt-vali-lote ~
                            tt-reporte-ordem-bc.dep-refugo ~
                            tt-reporte-ordem-bc.loc-refugo ~
                            tt-reporte-ordem-bc.qt-refugo ~
                            tt-reporte-ordem-bc.qt-apr-cond ~
                            tt-reporte-ordem-bc.op-codigo ~
                            tt-reporte-ordem-bc.cod-roteiro ~
                            tt-reporte-ordem-bc.it-oper ~
                            tt-reporte-ordem-bc.pto-controle ~
                            tt-reporte-ordem-bc.baixa-reservas ~
                            tt-reporte-ordem-bc.requis-automatica ~
                            tt-reporte-ordem-bc.finaliza-ordem ~
                            tt-reporte-ordem-bc.finaliza-oper ~
                            tt-reporte-ordem-bc.reserva ~
                            tt-reporte-ordem-bc.nro-ord-seq ~
                            tt-reporte-ordem-bc.linha ~
                            tt-reporte-ordem-bc.estado ~
                            tt-reporte-ordem-bc.cod-unico ~
                            tt-reporte-ordem-bc.cod-usuario ~
                            tt-reporte-ordem-bc.cod-livre-1 ~
                            tt-reporte-ordem-bc.cod-livre-2 ~
                            tt-reporte-ordem-bc.cod-livre-3 ~
                            tt-reporte-ordem-bc.num-livre-1 ~
                            tt-reporte-ordem-bc.num-livre-2 ~
                            tt-reporte-ordem-bc.num-livre-3 ~
                            tt-reporte-ordem-bc.dec-livre-1 ~
                            tt-reporte-ordem-bc.dec-livre-2 ~
                            tt-reporte-ordem-bc.dec-livre-3 ~
                            tt-reporte-ordem-bc.log-livre-1 ~
                            tt-reporte-ordem-bc.log-livre-2 ~
                            tt-reporte-ordem-bc.log-livre-3 ~
                            tt-reporte-ordem-bc.dat-livre-1 ~
                            tt-reporte-ordem-bc.dat-livre-2 ~
                            tt-reporte-ordem-bc.dat-livre-3

/********************  Frame Fields Preprocessor Definitions End  ***************/


/*****************  Name of TT Include Preprocessor Definitions Beg  ************/
&GLOBAL-DEFINE NameOfTTInclude bcp/bc9003.i
/*****************  Name of TT Include Preprocessor Definitions End  ************/


/*******************  Program Title Preprocessor Definitions Beg  ***************/
&GLOBAL-DEFINE ProgramTitle Reporte por Ordem - bc9003a.p 2.00.00.000
/*******************  Program Title Preprocessor Definitions End  ***************/


/**************  Frame Number of Columns Preprocessor Definitions Beg  **********/
&GLOBAL-DEFINE FrameNumOfColumns 3
/**************  Frame Number of Columns Preprocessor Definitions End  **********/


/*****************  Geracao Etiquetas Preprocessor Definitions Beg  *************/
&GLOBAL-DEFINE TransactionProgram bc9003
/*****************  Geracao Etiquetas Preprocessor Definitions End  *************/


/**********************  Table Preprocessor Definitions Beg  ********************/
&GLOBAL-DEFINE Table tt-reporte-ordem-bc
/**********************  Table Preprocessor Definitions End  ********************/

/**********************  Table Preprocessor Definitions Beg  ********************/
&GLOBAL-DEFINE TransDetail vCodTransaction + ~
                           " Doc: "        + String({&Table}.nro-docto)     + ~
                           " Item: "       + Trim(  {&table}.it-codigo)     + ~
                           " Depos: "      + Trim(  {&Table}.cod-depos)     + ~
                           " Local: "      + Trim(  {&Table}.cod-localiz)   + ~
                           " Tipo: "       + String({&Table}.tipo)          + ~
                           " Qtd: "        + String({&Table}.qt-reporte)


/**********************  Table Preprocessor Definitions End  ********************/


/**************  Fields Custom Display Preprocessor Definitions Beg  ************/
 /**************  Fields Custom Display Preprocessor Definitions End  ************/

/**************  Fields Custom Formats Preprocessor Definitions Beg  ************/

/**************  Fields Custom Formats Preprocessor Definitions End  ************/

{bcp/bc9106.i}
