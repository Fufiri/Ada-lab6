with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_Io; use Ada.Integer_Text_Io;
with Ada.Sequential_IO; 


procedure lab6an is
   
  
   
   type I_Array_Type is
     array (1..10) of Integer;
   
   Nummer_Error : exception; -- om talet är större än 15
   
      type Person_Type is
      record
	 Efternamn: String(1..20); 
	 Fornamn: String(1..20);
	 Gatuadress: String(1..20);
	 Postadress: String(1..20);
	 Antal: Integer;
	 Intressen: I_Array_Type;
      end record;
      
      package Person_Bin is
	 new Ada.Sequential_IO(Person_Type);
      use Person_Bin;
--------------------------------
function Contains(Item: in Integer; List: in I_Array_Type) return Boolean is
      
   begin
      
      for I in 1..10 loop
	 if Item = List(I) then
	    return True;
	 end if;
      end loop;
      
      return False;
      
   end Contains;
----------------------------------      
----------------------------------
procedure Get(Item: out I_Array_Type) is
   
   I_Temp: I_Array_Type;
   Nummer: Integer;
   Length: Integer := 0;
   
begin
   
 I_Temp := (others => 0); 
   
   loop
      Get(Nummer);
      exit when (Nummer = 0) or (Length >= 10);
      if (Nummer >= 16) or (Nummer < 0) then
	 raise Nummer_Error;
      elsif not Contains(Nummer, I_Temp) then
	 Length := Length+1;
	 I_Temp(Length) := Nummer;
      end if;
   end loop;
   
   Item := I_Temp;
   
end Get;
-----------------------------------
-----------------------------------
procedure Put(File: in Ada.Text_IO.File_Type; Item: in I_Array_Type) is   
   
begin
   
   for I in 1..10 loop
      Put(File, Item(I));
   end loop;
   
end Put;
-----------------------------------
-----------------------------------
function Remove(S: in String) return String is
   
begin
   
   for I in reverse S'First..S'Last loop
      if S(I)/= ' ' then
	 return S(S'First..I);
      end if;
   end loop;
   
   return S;
	   
end Remove;
------------------------------------
------------------------------------
procedure Put (File: in Ada.Text_IO.File_Type; Person: in Person_Type) is
   
begin
   
   New_Line(File);
   Put(File, "------------------------------------------------------------");
   New_Line(File);
   Put(File, Remove(Person.Fornamn));
   Put(File, " ");
   Put(File, Remove(Person.Efternamn));
   Put(File, " ");
   Put(File, Remove(Person.Gatuadress));
   Put(File, " ");
   Put(File, Remove("STAD ***"));
   Put(File, " ");
   Put(File, Remove("Intressen: "));
   for I in 1..Person.Antal loop
      Put(File, Remove(Integer'Image(Person.Intressen(I))));
   end loop;
   
   New_Line(File);	
   
end Put;
-----------------------------------
procedure Empty_Array(Item: in out I_Array_Type) is
   
begin
   
   for I in 1..10 loop
      Item(I) := 0;
   end loop;
   
end Empty_Array; 
-----------------------------------
function Compare(Left : in Person_Type; Right : in I_Array_Type) return Person_Type is
   
   Person: Person_Type;
   Length: Integer := 0;
   
begin
   
   Person := Left;
   Empty_Array(Person.Intressen);
   for I in 1..Person.Antal loop
      for N in 1..10 loop
	 if Left.Intressen(I) = Right(N) and Right(N)/= 0 then
	    Length := Length+1;
	    Person.Intressen(Length) := Left.Intressen(I);
	 end if;
      end loop;
   end loop;
   
   Person.Antal := Length;
   return Person;

end Compare; 
----------------------------------


   Reg : Person_Bin.File_Type;
   Output: Ada.Text_Io.File_Type;
   Person_Data : Person_Type;
   IAT : I_Array_Type := (others => 0);
   
begin
   
   Person_Bin.Open(Reg, In_File, "REG.BIN");
   Create(Output, Out_File, "RESULT.TXT");
   
   Put("Ange en Följd av intressen 1 till 15, max 10 st. Avsluta med 0: ");
  
   Get(IAT);
    
   while not End_Of_File(Reg) loop
      Person_Bin.Read(Reg, Person_Data);
      Person_Data := Compare(Person_Data, IAT);
      if Person_Data.Antal > 0 then
	 Put(Output, Person_Data);
      end if;   
   end loop;
   
   Put("Klart! Resultat finns i RESULT.TXT");
   
   Person_Bin.Close(Reg);
   Close(Output);

end lab6an;
