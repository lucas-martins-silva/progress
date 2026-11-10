/* Cabecalho */

FORM HEADER

      c-importador                                 AT 01                                                                         
      c-transporte                                 AT 77  SKIP
      c-estabel         AT 01           " ....:"   AT 16  tt-param.estab-ini                 AT 23 "-" 
                                                   AT 27  c-nome  FORMAT "x(30)" 
                                                   AT 29  
      c-via-transp      AT 77          "......:"   AT 91  tt-cabecalho.cd-via-transp-carg    AT 99 " - " c-desc-via      SKIP
      c-embarque        AT 01     "...........:"   AT 10  tt-param.embarque                  AT 23
      c-nm-transp       AT 77               ".:"   AT 96  tt-cabecalho.nm-transportador      AT 99 FORMAT "x(30)"        SKIP
      c-tipo-importador AT 01            "....:"   AT 17  tt-cabecalho.tipo-importador       AT 23             
      c-placa           AT 77  "..............:"   AT 83  tt-cabecalho.nr-veiculo-transp     AT 99                       SKIP    
      c-cgc-importador  AT 01           ".....:"   AT 16  c-cgc-imp                          AT 23                   
      c-embarcacao      AT 77       ".........:"   AT 88  tt-cabecalho.nm-veiculo-transp     AT 99                       SKIP
      c-pais            AT 01  "..............:"   AT 07  c-descricao-pais                   SKIP(1)
      c-conhec-transp   AT 01 
      c-frete-total     AT 77  SKIP                     
      c-identificacao   AT 01          "......:"   AT 15  tt-cabecalho.nr-docto-carga        AT 23         
      c-moeda-frete     AT 77        "........:"   AT 89  tt-cabecalho.cd-moeda-frete        AT 99 " - " tt-cabecalho.desc-mo-frete SKIP
      c-ident-master    AT 01                ":"   AT 21  tt-cabecalho.nr-docto-carga-master AT 23
      c-prepaid         AT 77    "............:"   AT 85  tt-cabecalho.vl-tot-frt-prepaid    AT 99                       SKIP
      c-local-embarque  AT 01           ".....:"   AT 16  tt-cabecalho.nm-local-embarque     AT 23  
      c-collect         AT 77    "............:"   AT 85  tt-cabecalho.vl-tot-frt-collect    AT 99                       SKIP
      c-dt-embarque     AT 01         ".......:"   AT 14  tt-cabecalho.dt-embarque           AT 23
      c-territorio      AT 77                ":"   AT 97  tt-cabecalho.vl-frete-tnac-mneg    AT 99                       SKIP(1)
      c-carga           AT 01                  
      c-carga-2         AT 77                  
      c-tipo-agente     AT 01          "......:"   AT 15  c-desc-ag-carga                    AT 23      
      c-tipo-consig     AT 77               ".:"   AT 96  c-desc-cons                        AT 99      SKIP
      c-agente-transp   AT 01                ":"   AT 21  c-cgc-agente                       AT 23        
      c-id-consig       AT 77             "...:"   AT 94  c-cgc-consig                       AT 99                       SKIP
      c-peso-liq        AT 01         ".......:"   AT 14  tt-cabecalho.pl-carga              AT 23 
      c-nm-consig       AT 77               ".:"   AT 96  tt-cabecalho.nm-consignatario      AT 99 FORMAT "x(30)"                      SKIP 
      c-peso-bruto      AT 01       ".........:"   AT 12  tt-cabecalho.pb-carga              AT 23 
      c-moeda-1         AT 77  "..............:"   AT 83  tt-cabecalho.cd-moeda-mle          AT 99 " - " tt-cabecalho.desc-moeda-mle   SKIP 
      c-cpf-repres      AT 01             "...:"   AT 18  c-nr-cpf-repres-legal              AT 23 FORMAT "999.999.999-99"
      c-vl-tot-merc     AT 77                ":"   AT 97  tt-cabecalho.vl-tot-mle-mn         AT 99                       SKIP(1)
      c-seguro          AT 01                  
      c-moeda-2         AT 01  "..............:"   AT 07  tt-cabecalho.cd-moeda-seguro       AT 23 " - " tt-cabecalho.desc-mo-seguro          
      c-valor-moeda     AT 77        "........:"   AT 89  tt-cabecalho.vl-tot-seguro-mneg    AT 99 SKIP(2)
      WITH WIDTH 132 STREAM-IO NO-LABEL NO-BOX  FRAME fr-cabecalho.

{utp/ut-liter.i Importador * R}              
ASSIGN c-importador = RETURN-VALUE.          
{utp/ut-liter.i Transporte * R}              
ASSIGN c-transporte = RETURN-VALUE.          
{utp/ut-liter.i Conhecimento_Transp * R}     
ASSIGN c-conhec-transp = RETURN-VALUE.       
{utp/ut-liter.i Estabelecimento * R}         
ASSIGN c-estabel = RETURN-VALUE.             
{utp/ut-liter.i Via_Transporte * R}          
ASSIGN c-via-transp = RETURN-VALUE.          
{utp/ut-liter.i Identifica‡Æo * R}           
ASSIGN c-identificacao = RETURN-VALUE.       
{utp/ut-liter.i Embarque * R}                
ASSIGN c-embarque = RETURN-VALUE.            
{utp/ut-liter.i Nome_Transportador * R}      
ASSIGN c-nm-transp = RETURN-VALUE.           
{utp/ut-liter.i Identifica‡Æo_Master * R}    
ASSIGN c-ident-master = RETURN-VALUE.        
{utp/ut-liter.i Tipo_Importador * R}         
ASSIGN c-tipo-importador = RETURN-VALUE.     
{utp/ut-liter.i Placa * R}                   
ASSIGN c-placa = RETURN-VALUE.               
{utp/ut-liter.i Local_Embarque * R}          
ASSIGN c-local-embarque = RETURN-VALUE.      
{utp/ut-liter.i CGC_Importador * R}          
ASSIGN c-cgc-importador = RETURN-VALUE.      
{utp/ut-liter.i Embarca‡Æo * R}              
ASSIGN c-embarcacao = RETURN-VALUE.          
{utp/ut-liter.i Data_Embarque * R}           
ASSIGN c-dt-embarque = RETURN-VALUE.         
{utp/ut-liter.i Pa¡s * R}                    
ASSIGN c-pais = RETURN-VALUE.                
{utp/ut-liter.i Carga_I * R}                 
ASSIGN c-carga = RETURN-VALUE.               
{utp/ut-liter.i Carga_II * R}                
ASSIGN c-carga-2 = RETURN-VALUE.             
{utp/ut-liter.i Frete_Total * R}             
ASSIGN c-frete-total = RETURN-VALUE.         
{utp/ut-liter.i Tipo_Ag_Carga * R}       
ASSIGN c-tipo-agente = RETURN-VALUE.         
{utp/ut-liter.i Tipo_Consignat rio * R}      
ASSIGN c-tipo-consig = RETURN-VALUE.         
{utp/ut-liter.i Moeda_Frete * R}             
ASSIGN c-moeda-frete = RETURN-VALUE.         
{utp/ut-liter.i Agente_Transportador * R}    
ASSIGN c-agente-transp = RETURN-VALUE.       
{utp/ut-liter.i Id_Consignat rio * R}        
ASSIGN c-id-consig = RETURN-VALUE.           
{utp/ut-liter.i Prepaid * R}                 
ASSIGN c-prepaid = RETURN-VALUE.             
{utp/ut-liter.i Peso_L¡quido * R}            
ASSIGN c-peso-liq = RETURN-VALUE.            
{utp/ut-liter.i Nome_Consignat rio * R}      
ASSIGN c-nm-consig = RETURN-VALUE.           
{utp/ut-liter.i Collect * R}                 
ASSIGN c-collect = RETURN-VALUE.             
{utp/ut-liter.i Peso_Bruto * R}              
ASSIGN c-peso-bruto = RETURN-VALUE.          
{utp/ut-liter.i Moeda * R}                   
ASSIGN c-moeda-1 = RETURN-VALUE.               
{utp/ut-liter.i Territ¢rio_Nacional * R}     
ASSIGN c-territorio = RETURN-VALUE.          
{utp/ut-liter.i CPF_Repres_Legal * R}        
ASSIGN c-cpf-repres = RETURN-VALUE.          
{utp/ut-liter.i Valor_Tot_Mercadoria * R}             
ASSIGN c-vl-tot-merc = RETURN-VALUE.         
{utp/ut-liter.i Seguro * R}                  
ASSIGN c-seguro = RETURN-VALUE.              
{utp/ut-liter.i Moeda * R}                   
ASSIGN c-moeda-2 = RETURN-VALUE.
{utp/ut-liter.i Valor_Moeda * R}  
ASSIGN c-valor-moeda = RETURN-VALUE.
