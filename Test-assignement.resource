*** Settings ***
Library    SeleniumLibrary 
Library    Collections       
Resource    Config.resource
Resource    locator.resource
Library    String 
       

*** Keywords ***

open browser
    [Documentation]    This keyword is to open the browser and open the page Webpage
    
    SeleniumLibrary.Open Browser    ${url}    ${browser}
    SeleniumLibrary.Maximize Browser Window
    SeleniumLibrary.Wait Until Page Contains Element    ${Cart_button}        
    
Add size to cart
    [Arguments]    ${item_to_be_selected}
    [Documentation]    This keyword is to add the given size item to the cart
    
     BuiltIn.Sleep    5   
     ${size_list}    BuiltIn.Create List        
    @{size_List_data} =     SeleniumLibrary.Get WebElements    xpath=${item_to_be_selected}
   # BuiltIn.Log To Console    @{size_List_data}
    :FOR    ${item}    IN    @{size_List_data}  
    \    SeleniumLibrary.Wait Until Element Is Visible    ${item}       
    \    SeleniumLibrary.Click Element    ${item} 
    \    BuiltIn.Sleep    2    
    \    SeleniumLibrary.Click Element    ${close_button}
    \                      

get installment count
    [Documentation]    This keyword is to get the count for the item having installment option
    
    BuiltIn.Sleep    15   
     ${price_list}    BuiltIn.Create List        
   
    ${installment_count} =     SeleniumLibrary.Get Element Count   xpath=${installment_item}
      
    [Return]    ${installment_count}

get all price on home page
    [Documentation]    To get the Price for each item on home page
    
     BuiltIn.Sleep    15   
     ${price_list}    BuiltIn.Create List        
    @{elList} =     SeleniumLibrary.Get WebElements    xpath=//*[@id="root"]//div[@class="val"]
    ${ecount} =     SeleniumLibrary.Get Element Count   xpath=//*[@id="root"]/main/div[2]/*/div[3]/div[1]/b
    ${tag_name}    SeleniumLibrary.Get Element Attribute    xpath=//*[@id="root"]//div[@class="val"]    tag:b
    #${blist}=     SeleniumLibrary.Get Text   xpath=//*[@id="root"]/main/div[2]/*/div[3]/div[1]/b      
    BuiltIn.Log To Console    ${tag_name}     
    :FOR    ${item}    IN    @{elList}
    \   
    \    ${val}    SeleniumLibrary.Get Text    ${item}
   # \    BuiltIn.Log To Console    ${val} 
    \    ${len}    BuiltIn.Get Length    ${val}
    \    ${first_two_char}    String.Get Substring    ${val}    0    2    
    \    ${removed_extra_char}    BuiltIn.Run Keyword If    '${first_two_char}'=='kr'    String.Get Substring    ${val}    2    ${len}
    \    ...    ELSE    String.Get Substring    ${val}    1    ${len}              
    \    ${only_price}    String.Replace String    ${removed_extra_char}    kr    ${SPACE} 
    \    ${int_price}    BuiltIn.Convert To Number    ${only_price}        
   # \    ${int_price}    BuiltIn.Convert To Integer    ${only_price}    
    \    Collections.Append To List    ${price_list}    ${int_price}   
    #Collections.Sort List    ${price_list}  
   # BuiltIn.Log To Console    ${price_list}         
    [Return]    ${price_list}

Select size on the page
    [Documentation]    This keyword is to sort the item based on Size
        
        
    SeleniumLibrary.Wait Until Element Is Enabled    ${Cart_button}

    @{sizes}    SeleniumLibrary.Get WebElements    ${Size}     
    ${count_size}    SeleniumLibrary.Get Element Count    ${Size}
    ${i}    BuiltIn.Set Variable    0  
    :FOR    ${item}    IN    @{sizes}
    \    ${i}    BuiltIn.Evaluate    ${i}+1        
    \    ${size_page}    SeleniumLibrary.Get Text     ${item} 
    \    ${required_Size}    BuiltIn.Run Keyword If    '${size_page}'=='${Expected_size}'    BuiltIn.Set Variable    ${Expected_size}
    \    ${Size_Element}=    BuiltIn.Run Keyword If    '${size_page}'=='${Expected_size}'    BuiltIn.Set Variable    ${item}  
    \    BuiltIn.Exit For Loop If    '${size_page}'=='${Expected_size}'
    \    ${not_available}    BuiltIn.Run Keyword If    ${i}==${count_size}   BuiltIn.Set Variable    TRUE
    \    BuiltIn.Run Keyword If    '${not_available}'=='TRUE'    BuiltIn.Log To Console    NO data found matching to expected size             
    \    BuiltIn.Exit For Loop If    '${not_available}'=='TRUE' 
     
    BuiltIn.Log To Console    ${required_Size}    
    
    SeleniumLibrary.Wait Until Element Is Enabled    ${Size_Element}
    BuiltIn.Sleep   2            
    SeleniumLibrary.Click Element    ${Size_Element} 
    BuiltIn.Sleep    5   
    Add size to cart    ${small_size_item}
    ${prod_list}     get product information from cart
    verify size is only S    ${prod_list}
    
  #  ${get_size_for_element}    
  

verify size is only S
    [Arguments]    ${prod_list}
    [Documentation]    This keyword is to verify if the Size of the item is matching with expected size
    
    ${size_len}    BuiltIn.Get Length    ${prod_list}
    :FOR    ${i}    IN RANGE    ${size_len} 
    \    ${size}    BuiltIn.Set Variable    ${prod_list}[${i}]      
    \    ${Exp_size_res}    BuiltIn.Run Keyword        BuiltIn.Run Keyword And Ignore Error    BuiltIn.Should Be Equal    ${size.strip()}    ${Expected_size.strip()}    
    \    BuiltIn.Log To Console    ${Exp_size_res}[1]    
    \    BuiltIn.Log To Console    ${Exp_size_res}[0]
    \    BuiltIn.Run Keyword If    '${Exp_size_res}[0]'=='FAIL'    BuiltIn.Run Keyword And Continue On Failure    BuiltIn.Fail    Size after filter does not match with expected    
    \    ...    ELSE    BuiltIn.Log To Console    Size matches with the expected Size    

get price for item in Cart
    [Documentation]    This keyword is to fetch the price of all the items which are added into cart
    

    @{items_for_price}    SeleniumLibrary.Get WebElements    ${ele_price_item_in_cart}
    ${item_price}    BuiltIn.Create List   
    ${sum_price}    BuiltIn.Set Variable    0 
    :FOR    ${item}    IN    @{items_for_price}
    \   SeleniumLibrary.Wait Until Element Is Visible    ${item}    
    \    ${val}    SeleniumLibrary.Get Text    ${item}
    \    ${val}    String.Split String    ${val}    ${SPACE}
    \    ${int_val}    BuiltIn.Convert To Number    ${val}[1]    
    \    ${sum_price}    BuiltIn.Evaluate    ${sum_price}+${int_val}    
    
    [Return]    ${sum_price}      
                      
get total price
    [Documentation]    This keyword is to fetch the Total price of all the items from cart
 
    ${Status}=     Run Keyword And Return Status    SeleniumLibrary.Element Should Be Visible    ${Cart_button}   
    BuiltIn.Run Keyword If    '${Status}'=='False'    SeleniumLibrary.Click Element    ${close_button}    
    SeleniumLibrary.Click Element    ${Cart_button} 
    SeleniumLibrary.Wait Until Element Is Visible    ${Sub_total}      
         
    ${sub_tot_page}    SeleniumLibrary.Get Text    ${Sub_total}
     #BuiltIn.Log To Console    ${sub_tot_page}
     SeleniumLibrary.Click Element    ${close_button}    
    [Return]    ${sub_tot_page}        


get product information from cart
    [Documentation]    This keyword is to get the information of the Product from the cart
    
        @{product_detail}     SeleniumLibrary.Get WebElements   //*[@id="root"]//p[@class="desc"]

        ${prod_list}    BuiltIn.Create List
        SeleniumLibrary.Wait Until Element Is Visible    ${Cart_button}    
        SeleniumLibrary.Click Element    ${Cart_button}            
       # @{size_List_data} =     SeleniumLibrary.Get WebElements    xpath=//*[@id="root"]//div[@class="shelf-item__thumb"]/img
   # BuiltIn.Log To Console    @{size_List_data}
        :FOR    ${item}    IN    @{product_detail}  
        \    SeleniumLibrary.Wait Until Element Is Visible    ${item}       
        \    ${product_data}    SeleniumLibrary.Get Text    ${item}
        #\    BuiltIn.Log To Console    ${product_data} in get prod info keyword
        \    ${size}    String.Split String    ${product_data}    |    
        \    Collections.Append To List    ${prod_list}    ${size}[0]
        \     SeleniumLibrary.Wait Until Element Is Visible    ${close_button}   
       SeleniumLibrary.Click Element    ${close_button}    
    BuiltIn.Log To Console    ${prod_list}                      
  [Return]    ${prod_list}     


Click on sort low to high price
    [Documentation]    This button is to cilck sorting from low to high
    
         
    SeleniumLibrary.Wait Until Element Is Enabled    ${cart_element}         
    SeleniumLibrary.Click Element    ${lower_price_dropdown} 
    BuiltIn.Sleep    5   
    ${sorted_list}   get all price on home page
    [Return]    ${sorted_list}  
get first element on the screen
   [Documentation]    This keyword is to get the price for the first element
    
     @{elList} =     SeleniumLibrary.Get WebElements    xpath=${first_item_price}
     ${price}    SeleniumLibrary.Get Text    xpath=${first_item_price}    
     #BuiltIn.Log To Console     ${price}
     [Return]    ${price}        
     

    
Click on sort high to low price
    [Documentation]    This keyword is to sort the itmes from high to low
          
    SeleniumLibrary.Wait Until Element Is Enabled    ${cart_element}         
    SeleniumLibrary.Click Element    ${high_price_dropdown} 
    BuiltIn.Sleep    5   
    ${sorted_list}   get all price on home page
    [Return]    ${sorted_list}
 

check no of product with installments
    [Documentation]    This keyword is to check the no of itments with installation option
    ${no_prod}         get installment count
    ${no_prod}    BuiltIn.Convert To String    ${no_prod}
    [Return]    ${no_prod}     
    
Go to Cart and checkout
    [Documentation]    This keyword is to go to the cart and click on the checkout 
    
    
    ${message_list}    BuiltIn.Create List    
    SeleniumLibrary.Wait Until Element Is Enabled    ${Size_text}
    BuiltIn.Sleep   3             
    
   
    
    #${staus}    SeleniumLibrary.Element Should Be Visible    ${empty_cart_msg}  
     ${counter}    get sub total from cart and compare
    #${counter}    BuiltIn.Run Keyword If    '${staus}'=='True'   BuiltIn.Set Variable    2
    #...    ELSE    get sub total from cart and compare
    SeleniumLibrary.Click Element    ${ele_btn_checkout}
    
    :FOR    ${i}    IN RANGE    ${counter}  
    \    ${message}      SeleniumLibrary.Handle Alert    action=ACCEPT 
    \    Collections.Append To List     ${message_list}    ${message}  
                   
      
    [Return]    ${message_list}     
get sub total from cart and compare
    [Documentation]    This keyword is to get the subtotal of the prices available in the cart and compare it
    
      SeleniumLibrary.Click Element    ${Cart_button}
      sleep    2
      SeleniumLibrary.Wait Until Element Is Visible    ${Sub_total}
      ${staus}    Element Exists   ${empty_cart_msg}    
      SeleniumLibrary.Wait Until Page Contains Element    ${Sub_total}    
      ${sub_total_amt}    SeleniumLibrary.Get Text    ${Sub_total}
      ${only_amt}    String.Split String    ${sub_total_amt}    ${SPACE}
      ${sub_total_int}=    BuiltIn.Convert To Number      ${only_amt}[1]
      ${item_cost_total}    BuiltIn.Run Keyword If     '${staus}'!='True'    get price for item in Cart
      ...    ELSE    BuiltIn.Set Variable    0
       
     ${alter_counter}    BuiltIn.Run Keyword If    ${item_cost_total}<${sub_total_int}    BuiltIn.Set Variable    2   
     ...    ELSE    BuiltIn.Set Variable    1 
    [Return]       ${alter_counter}    
    # ${alert_status}    BuiltIn.Run Keyword And Ignore Error    BuiltIn.Should Be Equal    ${message}    second            
    # ${message}    BuiltIn.Run Keyword If    '${alert_status}[0]'=='PASS'    BuiltIn.Log To Console    Alert is handeled           
    # ...    ELSE    BuiltIn.Fail    No alert is generated     
Element Exists
    [Documentation]  This keyword is to Determine if the desired element exists
    [Arguments]  ${xpath}
    ${imageCount} =  Get Matching Xpath Count  ${xpath}
    ${imageExists} =  Evaluate  ${imageCount} > 0
    [Return]  ${imageExists} 
    
add wine t-shrit
    [Documentation]    This keyword is to add the Wine T-shirt into cart
    ...    
    @{elemt}    SeleniumLibrary.Get WebElements    ${Ele_Shirt_to_be_selected}
    ${count_item}    SeleniumLibrary.Get Element Count    ${Ele_Shirt_to_be_selected}
    ${i}    BuiltIn.Set Variable    0
    :FOR    ${item}    IN    @{elemt} 
    \    ${i}    BuiltIn.Evaluate    ${i}+1    
    \    ${value}    SeleniumLibrary.Get Text    ${item}
    \    BuiltIn.Run Keyword If    '${value}'=='${Expected_item_tobe_added}'    SeleniumLibrary.Click Element   ${item}
    \    BuiltIn.Exit For Loop If    '${value}'=='${Expected_item_tobe_added}'
     \    ${not_available}    BuiltIn.Run Keyword If    ${i}==${count_item}   BuiltIn.Set Variable    TRUE
    \    BuiltIn.Run Keyword If    '${not_available}'=='TRUE'    BuiltIn.Log To Console    NO data found matching to expected size             
    \    BuiltIn.Exit For Loop If    '${not_available}'=='TRUE'
    BuiltIn.Sleep    1    
    ${status}     Element Exists     ${close_button}
    BuiltIn.Run Keyword If    '${status}'=='True'    SeleniumLibrary.Click Element    ${close_button}        
   # ...    ELSE        SeleniumLibrary.Click Element    ${Cart_button}       
            
    # sleep    1  # Add size to cart    ${ele_wine_shirt}
    #SeleniumLibrary.Click Element    ${close_button}    
    
        