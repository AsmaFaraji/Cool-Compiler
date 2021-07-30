Class Scanner inherits IO 
{
	read() : String 
	{
        	{
            		out_string("> ");
            		in_string();
        	}
    	};
};



Class StackMachine inherits IO
{
	stack : Stack ; 
	intfunctions : IntegerFunctions ;
	scanner : Scanner ;
	
	init() : StackMachine
	{{
		stack <- (new Stack).init() ;
		intfunctions <- new IntegerFunctions ;
		scanner <- new Scanner ;
		self;
	}};
	
	read() : String
	{{
		
		(let ifstop : Bool <- false, shouldstop : Bool <- false in 
		{
                	while ifstop = false loop 
			{
				out_string("salaam");
                   		(let input : String <- scanner.read() in 
				{
					
                        		shouldstop <- checkCommand(input).run(stack);
					
                        		if(shouldstop = true)
                        		then
                            			ifstop <- true
                        		else 
                            			ifstop <- false
                        		fi;   
                    		});
                	} pool;
            	});
		
            	"StackMachine halts successfully";
	}};

	checkCommand(command : String) : Command 
	{
        	if(command = "x") 
            	then
                	new StopSign
            	else
                	if(command = "+")
               		then
                    		new PlusSign
                	else
                    		if(command = "s")
                    		then
                        		new SwapSign
                    		else
                        		if(command = "e")
                        		then
                            			new EvalSign
                        		else
                            			if(command = "d")
                            			then
                                			new DisplaySign
                            			else
                                			if(intfunctions.isInteger(command))
                                			then
                                    				(new IntSign).setnum(command)
                                			else
                                    			{
								out_string("StackMachine: command not found".concat(" \n")) ;
                                        			new Command;
                                    			}
                                			fi
                            			fi
                        		fi
                    		fi
                	fi
            	fi      
	};
};

Class Stack inherits IO
{
	firstnode : Nodes ;
	size : Int ;
	
	init() : Stack
	{{
		size <- 0 ;
		self;
	}};	

	size() : Int 
	{
		size
	};

 	head() : String 
	{ 
        	if(size = 0)
        	then 
		{
            		out_string("stack is empty".concat(" \n")) ;
            		abort();
            		firstnode.data();
        	} 
		else 
		{
            		firstnode.data();
        	}
        	fi
    	};

	 push(input : String) : Stack 
	 {
         	(let node : Nodes <- (new Nodes).init(input) in 
		{
            		node.setNextNode(firstnode);
            		firstnode <- node;
            		size <- size + 1;
            		self;
        	})
    	};


	pop() : String 
	{
        	if(size = 0)
        	then 
		{
            		out_string("stack is empty".concat(" \n")) ;
            		abort();
            		"";
        	} 
		else 
		{
            		(let commandToPop : String <-head() in 
			{
                		firstnode <- firstnode.next();
                		size <- size - 1;
                		commandToPop;
            		});
        	}
        	fi
    	};

	print() : Stack 
	{
        {
            out_string("stack is: ".concat(" \n")) ;
            if(size = 0)
            	then 
		{
                	out_string("\tstack is empty".concat(" \n")) ;
            	} 
		else 
		{
                	(let stackitem : Nodes <- firstnode in 
			{
                    		while (isvoid stackitem) = false loop 
				{
                        		out_string("\t".concat(stackitem.data().concat(
                            			if(isvoid stackitem.next())
                            			then "" 
						else "," 
						fi
                        			)));
                        		stackitem <- stackitem.next();
                    		}
                    		pool;
                	});

            	}
            fi;
            self;
        }
    	};

};


Class Nodes
{
	data : String ;
	nextnode : Nodes ;

	init(input : String) : Nodes
	{
	{
		data <- input ;
		self ;
	}	
	};

	setNextNode(inputnode : Nodes) : Nodes
	{
	{
		nextnode <- inputnode ;
		self;
	}
	};

	data() : String
	{ 
		data
	};

	next() : Nodes
	{
		nextnode
	};


};


Class IntegerFunctions
{
	isInteger(command : String) : Bool
	{
		(let isNumber : Bool <- true,
		length : Int <- command.length(),
		counter : Int <- 0
		in
		{
			while (counter = length) = false 
			loop 
			{
				if(isDigit(command.substr(counter,1)) = false)
				then 
					isNumber <- false
				else
					""
				fi;
				counter <- counter +1 ;
			} 
			pool;
			isNumber ;
		})
	};
	 
	isDigit(character : String) : Bool 
	{
		if character = "1" then true else
		if character = "2" then true else
        	if character = "0" then true else
        	if character = "3" then true else
        	if character = "4" then true else
        	if character = "5" then true else
        	if character = "6" then true else
        	if character = "7" then true else
        	if character = "8" then true else
        	if character = "9" then true else
            	false
        	fi fi fi fi fi fi fi fi fi fi
    	};

	
    	charToInt(character : String) : Int 
	{
		if character = "0" then 0 else
    		if character = "1" then 1 else
		if character = "2" then 2 else
        	if character = "3" then 3 else
        	if character = "4" then 4 else
        	if character = "5" then 5 else
        	if character = "6" then 6 else
        	if character = "7" then 7 else
        	if character = "8" then 8 else
        	if character = "9" then 9 else
            	{ abort(); 0; }
        	fi fi fi fi fi fi fi fi fi fi
   	 };



	intToChar(integer : Int) : String 
	{
        	if integer = 0 then "0" else
        	if integer = 1 then "1" else
        	if integer = 2 then "2" else
        	if integer = 3 then "3" else
        	if integer = 4 then "4" else
        	if integer = 5 then "5" else
        	if integer = 6 then "6" else
        	if integer = 7 then "7" else
        	if integer = 8 then "8" else
        	if integer = 9 then "9" else
	        { abort(); ""; }
        	fi fi fi fi fi fi fi fi fi fi
	};



	strToInt(string : String) : Int 
	{
        	if string.length() = 0 then 0 else
	    	if string.substr(0,1) = "-" 
			then ~strToIntHelper(string.substr(1,string.length()-1)) 
		else
        		if string.substr(0,1) = "+" 
				then strToIntHelper(string.substr(1,string.length()-1)) 
			else
            			strToIntHelper(string)
        	fi fi fi
    	};


	strToIntHelper(string : String) : Int 
	{
		(let tmp : Int <- 0 in 
		{	
        		(let j : Int <- string.length() in
	        	(let i : Int <- 0 in
		        	while i < j loop
			        {
			        	tmp <- tmp * 10 + charToInt(string.substr(i,1));
			        	i <- i + 1;
			        }
		        	pool
		        )
	        	);
        		tmp;
	    	})
    	};


	intToStr(integer : Int) : String 
	{
		if integer = 0 
			then "0" 
		else 
        		if 0 < integer 
				then intToStrHelper(integer) 
			else
          			"-".concat(intToStrHelper(integer * ~1)) 
        	fi fi
    	};

	intToStrHelper(integer : Int) : String 
	{
        	if integer = 0 
			then "" 
		else 
	    		(let next : Int <- integer / 10 in
				intToStrHelper(next).concat(intToChar(integer - next * 10))
	    		)
        	fi
    	};

};


Class Command
{
	run(stack : Stack) : Bool
	{
		false
	};
};

Class StopSign inherits Command
{
	run(stack : Stack) : Bool
	{
		true
	};
};

Class PlusSign inherits Command
{
	run(stack : Stack) : Bool
	{{
		stack.push("+") ;
		false ;
	}};
};

Class SwapSign inherits Command
{
	run(stack : Stack) : Bool
	{{
		stack.push("s") ;
		false ;
	}};
};

Class DisplaySign inherits Command
{
	run(stack : Stack) : Bool
	{{
		stack.print() ;
		false ;
	}};
};

Class IntSign inherits Command
{
	mem : String ;
	run(stack : Stack) : Bool
	{{
		stack.push(mem) ;
		false ;
	}};

	setnum(number : String) : IntSign
	{{
		mem <- number ;
		self;
	}};
};

Class EvalSign inherits Command
{
	run(stack : Stack) : Bool
	{
		if(stack.size() = 0)
			then
				false
		else
		{
            		(let intf : IntegerFunctions <- new IntegerFunctions in 
			{
                		if(intf.isInteger(stack.head()))
                			then
                    				false
                		else
                    			if(stack.head() = "s")
                    				then 
						{
                        				stack.pop();
                        				(let firstCommand : String <- stack.pop(), 
                        				secondCommand : String <- stack.pop() in 
							{
                            					stack.push(firstCommand);
                            					stack.push(secondCommand);
                        				});

                        				false;
                    				}
                    			else
                        			if(stack.head() = "+")
                        				then 
							{
                            					stack.pop();
                            					(let firstOperand : Int <- intf.strToInt(stack.pop()), 
                            					secondOperand : Int <- intf.strToInt(stack.pop()) in 
								{
                                					stack.push(intf.intToStr(firstOperand + secondOperand));
                            					});

                            					false;
                        				}
                        			else 
						{
                            				"Never happens";
                            				false;
                        			}
                        			fi
                    			fi
                		fi;    
			});
		}
        	fi
	};
};

Class Main inherits IO 
{
	main() : Object 
	{
		let machine : StackMachine <- (new StackMachine).init() in 
		{
            		out_string(machine.read().concat(" \n"));
        	}
	};
};