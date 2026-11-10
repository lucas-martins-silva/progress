/********************************************************************************************
**   Programa..: bc9001a.p                                                                 **
**                                                                                         **
**   Versao....: 2.00.00.000 - dez/1999 - John Cleber Jaraceski                            **
**                                                                                         **
**   Objetivo..: Teste para o programa de Transferencia de Materiais (bcp/bc9001.p)        **
**                                                                                         **
**   Includes..: bcp/bc9106.i                                                              **
**                                                                                         **
********************************************************************************************/
{include/i-prgvrs.i BC9040A 2.00.00.010 } /*** 010010 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i BC9040A MBC}
&ENDIF
/********************  Frame Fields Preprocessor Definitions Beg  ***************/
&GLOBAL-DEFINE FrameFields  tt-trans-02.cod-versao-integracao ~
                            tt-trans-02.i-sequen              ~
                            tt-trans-02.cd-trans              ~
                            tt-trans-02.usuario               ~
                            tt-trans-02.atualizada            ~
                            tt-trans-02.etiqueta

/********************  Frame Fields Preprocessor Definitions End  ***************/

/*****************  Name of TT Include Preprocessor Definitions Beg  ************/
&GLOBAL-DEFINE NameOfTTInclude bcp/bc9040.i
/*****************  Name of TT Include Preprocessor Definitions End  ************/


/*******************  Program Title Preprocessor Definitions Beg  ***************/
&GLOBAL-DEFINE ProgramTitle Altera‡Æo C¢digo ITEM(cd0205) - bc9040a.p 2.00.00.000
/*******************  Program Title Preprocessor Definitions End  ***************/


/**************  Frame Number of Columns Preprocessor Definitions Beg  **********/
&GLOBAL-DEFINE FrameNumOfColumns 2
/**************  Frame Number of Columns Preprocessor Definitions End  **********/


/*****************  Geracao Etiquetas Preprocessor Definitions Beg  *************/
&GLOBAL-DEFINE TransactionProgram bc9040
/*****************  Geracao Etiquetas Preprocessor Definitions End  *************/


/**********************  Table Preprocessor Definitions Beg  ********************/
&GLOBAL-DEFINE Table tt-trans-02
/**********************  Table Preprocessor Definitions End  ********************/

/**********************  Table Preprocessor Definitions Beg  ********************/
&GLOBAL-DEFINE TransDetail vCodTransaction + ~
                           " Detalhe: ":U + String({&Table}.detalhe)

/**********************  Table Preprocessor Definitions End  ********************/


/**************  Fields Custom Display Preprocessor Definitions Beg  ************/
/**************  Fields Custom Display Preprocessor Definitions End  ************/

/**************  Fields Custom Formats Preprocessor Definitions Beg  ************/

/**************  Fields Custom Formats Preprocessor Definitions End  ************/

{bcp/bc9106.i}
