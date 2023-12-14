from pyswip import Prolog
import re
import random

prolog = Prolog()
prolog.consult("knowledgebase.pl")
string_lst = ['siblings', 'sister', 'mother', 'grandmother', 'child', 'daughter', 'uncle', 'brother', 'father', 'grandfather', 'parent', 'son', 'aunt', 'relatives']

males = ['uncle', 'brother', 'father', 'grandfather', 'son']
females = ['sister', 'mother', 'grandmother', 'aunt', 'daughter']

print("Welcome to CHATBOT! (Input -1 to End)")
prompt = input("> ")
while prompt != '-1':
    if(re.search(r"(?=(\b" + '|'.join(string_lst) + r"\b))", prompt)):
        rel = re.search(r"(?=(\b" + '|'.join(string_lst) + r"\b))", prompt).group(1)
        
        if prompt[-1] == '?':
            if prompt.split(' ', 1)[0].lower() == 'who':
                name = prompt.rsplit(None, 1)[-1].lower()[:-1]
                query = rel + '(' + 'X' + ',' + name + ')'
                result = set()
                for soln in list(prolog.query(query)):
                    result.add(soln['X'].title())
                for i in result:
                    print(i)
                    
            elif prompt.split(' ', 1)[0].lower() == 'is':
                name_1 = re.search(r'Is (\w+)', prompt).group(1).lower()
                name_2 = prompt.rsplit(None, 1)[-1].lower()[:-1]
                query = rel + '(' + name_1 + ',' + name_2 + ')'
                not_query = 'not_' + rel + '(' + name_1 + ',' + name_2 + ')'
                result = bool(list(prolog.query(query)))
                not_result = bool(list(prolog.query(not_query)))
                print(result)
                print(not_result)
                if result:
                    print("Yes!")
                else:
                    print("No!")
                    
            elif prompt.split(' ', 1)[0] == 'Are':
                name_1 = re.search(r'Are (\w+)', prompt).group(1).lower()
                name_2 = re.search(r'and (\w+)', prompt).group(1).lower()
                if rel == 'parent':
                    name_3 = prompt.rsplit(None, 1)[-1].lower()[:-1]
                    query1 = 'parent' + '(' + name_1 + ',' + name_3 + ')'
                    query2 = 'parent' + '(' + name_2 + ',' + name_3 + ')'
                    
                    not_query1 = 'not_parent' + '(' + name_1 + ',' + name_3 + ')'
                    not_query2 = 'not_parent' + '(' + name_2 + ',' + name_3 + ')'
                    result = bool(list(prolog.query(query1))) and bool(list(prolog.query(query2)))
                    not_result = bool(list(prolog.query(not_query1))) and bool(list(prolog.query(not_query2)))
                elif re.search(r'(\w+), (\w+)', prompt):
                    namesList = re.findall(r', (\w+)', prompt)
                    parent_name = prompt.rsplit(None, 1)[-1].lower()[:-1]
                    result = True
                    for name in namesList:
                        query = rel + '(' + name.lower() + ',' + parent_name + ')'
                        check = bool(list(prolog.query(query)))
                        if not check:
                            result = False
                else:
                    query = rel + '(' + name_1 + ',' + name_2 + ')'
                    print(query)
                    result = bool(list(prolog.query(query)))
                    print(result)
                    not_result = False
                if result:
                    print("Yes!")
                else:
                    print("No!")
            else: 
                print('Invalid Input')  
                
        elif prompt[-1] == '.':
            if re.search(r'(\w+), (\w+)', prompt):
                name_1 = prompt.split(' ', 1)[0].lower()[:-1]
                namesList = re.findall(r', (\w+)', prompt)
                name_end = re.search(r'and (\w+)', prompt).group(1).lower()
                parent_name = prompt.rsplit(None, 1)[-1].lower()[:-1]
                fact1 = rel + '(' + name_1 + ',' + parent_name + ')'
                negfact1 = 'not_child'+ '(' + name_1 + ',' + parent_name + ')'
                fact_end = rel + '(' + name_end + ',' + parent_name + ')'
                negfact_end = 'not_child'+ '(' + name_end + ',' + parent_name + ')'
                if(not bool(list(prolog.query(fact1))) and not bool(list(prolog.query(negfact1))) and not bool(list(prolog.query(fact_end))) and not bool(list(prolog.query(negfact_end)))):
                    check = True
                    for name in namesList:
                        query = rel + '(' + name.lower() + ',' + parent_name + ')'
                        notquery = 'not_child'+ '(' + name.lower() + ',' + parent_name + ')'
                        checkIs = bool(list(prolog.query(query)))
                        checkNot = bool(list(prolog.query(notquery)))
                        if(checkIs or checkNot):
                            check = False
                            break
                        
                    if(check):
                        prolog.assertz(rel + 'T' + '(' + name_1 + ',' + parent_name + ')')

                        for name in namesList:
                            query = rel + '(' + name.lower() + ',' + parent_name + ')'
                            prolog.assertz(rel + 'T' + '(' + name.lower() + ',' + parent_name + ')')
                            
                        prolog.assertz(rel + 'T' + '(' + name_end + ',' + parent_name + ')')
                        print('OK! I learned something.')
                    else:
                        print("That's impossible!")
                else:
                    print("That's impossible!")
                
            elif re.search(r'(\w+) and (\w+)', prompt):
                name_1 = prompt.split(' ', 1)[0].lower()
                name_2 = re.search(r'and (\w+)', prompt).group(1).lower()
                if(rel == 'parent'):
                    name_3 = prompt.rsplit(None, 1)[-1].lower()[:-1]
                    
                    fact1 = rel + '(' + name_1 + ',' + name_3 + ')'
                    neg_fact1 = 'not_' + rel + '(' + name_1 + ',' + name_3 + ')'
                    fact2 = rel + '(' + name_2 + ',' + name_3 + ')'
                    neg_fact2 = 'not_' + rel + '(' + name_2 + ',' + name_3 + ')'

                    checkfact1 = bool(list(prolog.query(fact1)))
                    checknegfact1 = bool(list(prolog.query(neg_fact1)))
                    if(checknegfact1):
                        print("That's impossible!")
                    elif(checkfact1):
                        print("I already know that!")
                    elif(not checkfact1 and not checknegfact1):
                        print('OK! I learned something.')
                        prolog.assertz(rel + 'T' + '(' + name_1 + ',' + name_3 + ')')
                    
                    checkfact2 = bool(list(prolog.query(fact2)))
                    checknegfact2 = bool(list(prolog.query(neg_fact2)))
                    if(checknegfact2):
                        print("That's impossible!")
                    elif(checkfact2):
                        print("I already know that!")
                    elif(not checkfact2 and not checknegfact2):
                        print('OK! I learned something.')
                        prolog.assertz(rel + 'T' + '(' + name_2 + ',' + name_3 + ')')
                else:
                    fact1 = rel + '(' + name_1 + ',' + name_2 + ')'
                    fact2 = 'not_siblings' + '(' + name_1 + ',' + name_2 + ')'
                    check1 = bool(list(prolog.query(fact1)))
                    check2 = bool(list(prolog.query(fact2)))
                    if(check2):
                        print("That's impossible!")
                    elif(check1):
                        print("I already know that!")
                    elif(not check1 and not check2):
                        print('OK! I learned something.')
                        prolog.assertz('siblingsT' + '(' + name_1 + ',' + name_2 + ')')

                        
            elif re.search(r'(\w+) is', prompt):
                name_1 = prompt.split(' ', 1)[0].lower()
                name_2 = prompt.rsplit(None, 1)[-1].lower()[:-1]
                fact1 = rel + '(' + name_1 + ',' + name_2 + ')'
                fact2 = 'not_' + rel + '(' + name_1 + ',' + name_2 + ')'
                check1 = bool(list(prolog.query(fact1)))
                check2 = bool(list(prolog.query(fact2)))
                if(check2):
                    print("That's impossible!")
                elif(check1):
                    print("I already know that!")
                elif(not check1 and not check2):
                    print('OK! I learned something.')
                    prolog.assertz(rel + 'T' + '(' + name_1 + ',' + name_2 + ')')
                    if rel in males:
                        prolog.assertz('male(' + name_1 + ')')
                    elif rel in females:
                        prolog.assertz('female(' + name_1 + ')')
                
    else:
        print('Invalid Input')
    
    prompt = input("> ")