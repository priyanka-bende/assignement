*** Settings ***
Resource    Test-assignement.resource
Resource    Config.resource

   

*** Test Cases ***

    
TC01:Validate whether the products can be sorted Lowest to Highest and assert the price of first product is kr 9.000
    Test-assignement.open browser
     ${expected_list}   get all price on home page   
     Collections.Sort List    ${expected_list}
     ${sorted_list_dropdown}  Test-assignement.Click on sort low to high price
     ${sorting_res}    BuiltIn.Run Keyword And Ignore Error            Collections.Lists Should Be Equal    ${expected_list}     ${sorted_list_dropdown}
     BuiltIn.Run Keyword If    '${sorting_res}[0]'=='FAIL'    BuiltIn.Fail    list does not match due to ${sorting_res}[1]    
     ...    ELSE    BuiltIn.Log To Console   list matches           

 
    ${price_from_screen}    get first element on the screen
     ${assert_result}    BuiltIn.Run Keyword And Ignore Error       BuiltIn.Should Be Equal    ${price_from_screen}    ${Expected_low_price}
     BuiltIn.Run Keyword If    '${assert_result}[0]'=='FAIL'    BuiltIn.Fail    price does not match due to ${assert_result}[1]    
     ...    ELSE    BuiltIn.Log To Console    Test case Pass  
     SeleniumLibrary.Close Browser         
   # Test-assignement.Click on sort low to high price
TC02:Validate whether the products can be sorted Highest to Lowest and assert the price of first product is kr134.900
      Test-assignement.open browser
     ${expected_list}   get all price on home page   
     Collections.Sort List    ${expected_list}
     Collections.Reverse List    ${expected_list}
     ${sorted_list_dropdown}  Test-assignement.Click on sort high to low price
     ${sorting_res}    BuiltIn.Run Keyword And Ignore Error            Collections.Lists Should Be Equal    ${expected_list}     ${sorted_list_dropdown}
     BuiltIn.Run Keyword If    '${sorting_res}[0]'=='FAIL'    BuiltIn.Fail    list does not match due to ${sorting_res}[1]    
     ...    ELSE    BuiltIn.Log To Console   list matches    
            
     Collections.Lists Should Be Equal    ${expected_list}     ${sorted_list_dropdown} 
    ${price_from_screen}    get first element on the screen
     ${assert_result}    BuiltIn.Run Keyword And Ignore Error       BuiltIn.Should Be Equal    ${price_from_screen}    ${Expected_high_price}
     BuiltIn.Run Keyword If    '${assert_result}[0]'=='FAIL'    BuiltIn.Fail    price does not match due to ${assert_result}[0]    
     ...    ELSE    BuiltIn.Log To Console    Test case Pass           
    SeleniumLibrary.Close Browser  
    
TC03:Validate whether the products can be filtered by selecting Size S and assert the combined price of items is kr 33.400
       Test-assignement.open browser
       Test-assignement.Select size on the page
       ${Total_price}    get total price
       SeleniumLibrary.Close Browser
       ${Compare_price_res}    BuiltIn.Run Keyword And Ignore Error    BuiltIn.Should Be Equal    ${Total_price}    ${Expected_size_price}
      # BuiltIn.Log To Console    ${Compare_price_res}[1]      
      SeleniumLibrary.Close Browser    
       BuiltIn.Run Keyword If    '${Compare_price_res}[0]'=='FAIL'    BuiltIn.Fail    price does not match due to ${Compare_price_res}[1]    
       ...    ELSE    BuiltIn.Run Keyword    BuiltIn.Log To Console  Testcase is paasses and price matches            
        
TC04:Select only the products which have installments and assert the total number of products is 15
    Test-assignement.open browser
    ${Installmet_product_count}    check no of product with installments
   
    ${Installment_count_result}    BuiltIn.Run Keyword And Ignore Error    BuiltIn.Should Be Equal    ${Installmet_product_count}    ${Expected_installment_count} 
     SeleniumLibrary.Close Browser    
    BuiltIn.Run Keyword If    '${Installment_count_result}[0]'=='FAIL'    BuiltIn.Fail    count for the installment products does not match due to ${Installment_count_result}[1]    
    ...    ELSE    BuiltIn.Log To Console    count for installment product is matching  

TC05:Without selecting any product, go to cart and click on Checkout. Assert the text in Alert box is "Add some product in the cart!"
    Test-assignement.open browser
    ${alert_message}    Test-assignement.Go to Cart and checkout
    SeleniumLibrary.Close Browser
    ${alert_message_result}    BuiltIn.Run Keyword And Ignore Error    BuiltIn.Should Be Equal    ${alert_message}[0]    ${alert_message}
    BuiltIn.Run Keyword If    '${alert_message_result}[0]'=='FAIL'    BuiltIn.Fail    Alert message is mismatched${alert_message_result}[1]    
    ...    ELSE    BuiltIn.Log To Console    Alert message is matched  

TC06:Select "Sphynx Tie Dye Wine T-Shirt", go to checkout and handel the alerts
    Test-assignement.open browser
    add wine t-shrit
     @{alert_message}    Test-assignement.Go to Cart and checkout
     SeleniumLibrary.Close Browser
     Collections.Log List    ${alert_message}         
  

     