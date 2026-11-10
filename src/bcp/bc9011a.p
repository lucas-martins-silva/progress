/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC9011A 2.00.00.005 } /*** 010005 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i bc9011a MBC}
&ENDIF


/********************************************************************************************
**   Programa..: bc9011a.p                                                                 **
**                                                                                         **
**   Versao....: 2.00.00.000 - jun/2001 - Carlos Alberto Soares Pereira                    **
**                                                                                         **
**   Objetivo..: Requisicao de Materiais Ordem de Manutencao                               **
**                                                                                         **
**   Includes..: bcp/bc9106.i                                                              **
**                                                                                         **
********************************************************************************************/

/********************  Frame Fields Preprocessor Definitions Beg  ***************/
&GLOBAL-DEFINE FrameFields  tt-requis-manut-bc.cod-estabel      ~
                            tt-requis-manut-bc.nro-docto        ~
                            tt-requis-manut-bc.serie-docto      ~
                            tt-requis-manut-bc.dt-trans         ~
                            tt-requis-manut-bc.numero-ordem     ~
                            tt-requis-manut-bc.op-codigo        ~
                            tt-requis-manut-bc.it-codigo        ~
                            tt-requis-manut-bc.cod-refer        ~
                            tt-requis-manut-bc.cod-depos        ~
                            tt-requis-manut-bc.localizacao      ~
                            tt-requis-manut-bc.lote             ~
                            tt-requis-manut-bc.quantidade       ~
                            tt-requis-manut-bc.dt-validade-lote 



/********************  Frame tt-requis-manut-bcs Preprocessor Definitions End  ***************/


/*****************  Name of TT Include Preprocessor Definitions Beg  ************/
&GLOBAL-DEFINE NameOfTTInclude bcp/bc9011.i
/*****************  Name of TT Include Preprocessor Definitions End  ************/


/*******************  Program Title Preprocessor Definitions Beg  ***************/
&GLOBAL-DEFINE ProgramBC9011A
/*******************  Program Title Preprocessor Definitions End  ***************/


/**************  Frame Number of Columns Preprocessor Definitions Beg  **********/
&GLOBAL-DEFINE FrameNumOfColumns 2
/**************  Frame Number of Columns Preprocessor Definitions End  **********/


/*****************  Geracao Etiquetas Preprocessor Definitions Beg  *************/
&GLOBAL-DEFINE TransactionProgram bc9011
/*****************  Geracao Etiquetas Preprocessor Definitions End  *************/

/**********************  Table Preprocessor Definitions Beg  ********************/
&GLOBAL-DEFINE Table tt-requis-manut-bc
/**********************  Table Preprocessor Definitions End  ********************/

/**********************  Table Preprocessor Definitions Beg  ********************/
&GLOBAL-DEFINE TransDetail vCodTransaction + ~
                           " Doc: "        + TRIM(  {&Table}.nro-docto)     + ~
                           " Item: "       + Trim(  {&table}.it-codigo)     + ~
                           " Ref: "        + Trim(  {&Table}.cod-refer)     + ~
                           " Depos: "      + Trim(  {&Table}.cod-depos)     + ~
                           " Local: "      + Trim(  {&Table}.localizacao)   + ~
                           " Lote: "       + Trim(  {&Table}.lote)          + ~
                           " Qt: "         + String({&Table}.quantidade)

/**********************  Table Preprocessor Definitions End  ********************/


/**************  Fields Custom Display Preprocessor Definitions Beg  ************/
/**************  Fields Custom Display Preprocessor Definitions End  ************/

/**************  Fields Custom Formats Preprocessor Definitions Beg  ************/

/**************  Fields Custom Formats Preprocessor Definitions End  ************/

{bcp/bc9106.i}
