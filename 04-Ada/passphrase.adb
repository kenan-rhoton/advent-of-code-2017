with Ada.Text_IO,
    Ada.Strings.Unbounded,
    Ada.Text_IO.Unbounded_IO,
    Ada.Containers.Ordered_Sets,
    Ada.Containers.Generic_Array_Sort;
use Ada.Text_IO,
    Ada.Strings.Unbounded;

procedure Passphrase is
    package String_Sets is new Ada.Containers.Ordered_Sets(Unbounded_String);
    use String_Sets;
    procedure String_Sort is
           new Ada.Containers.Generic_Array_Sort (Positive, Character, String);
    procedure Break (s : Unbounded_String; u : in out Set; b : in out Boolean) is
        i : Integer := Index (s, " ");
        t : Cursor;
    begin
        if Length(s) > 0 then
            if i < 1 then
                u.Insert (s, t, b);
            else
                u.Insert (To_Unbounded_String (Slice (s, 1, i-1)), t, b);
                if b then
                    Break (To_Unbounded_String (Slice (s, i+1, Length(s))), u, b);
                end if;
            end if;
        end if;
    end Break;
    procedure Unbounded_String_Sort(w : in out Unbounded_String) is
        s : String (1 .. Length(w)) := To_String(w);
    begin
        String_Sort(s);
        w := To_Unbounded_String(s);
    end Unbounded_String_Sort;
    procedure AnagramCheck (u : Set; b : in out Boolean) is
        cur : Cursor := First (u);
        s : Set;
        throwaway : Cursor;
        word : Unbounded_String;
        variable_word : Unbounded_String;
    begin
        iter:
        for word of u loop
            variable_word := word;
            Unbounded_String_Sort(variable_word);
            Insert(s, variable_word, throwaway, b);
            exit iter when not b;
        end loop iter;
    end AnagramCheck;
    Str  : Unbounded_String;
    Unique : Set;
    Set_Cur : Cursor;
    Success : Boolean;
    Counter : Integer := 0;
    AnagramCounter : Integer := 0;
begin
    while not End_of_File loop
        
        Str := Ada.Strings.Unbounded.
            To_Unbounded_String(Ada.Text_IO.Get_Line);

        Unique.Clear;
        Success := True;
        Break (Str, Unique, Success);

        if Success then
            Counter := Counter + 1;
            AnagramCheck (Unique, Success);
        end if;
            
        if Success then
            AnagramCounter := AnagramCounter + 1;
        end if;
    end loop;
    Put_Line (Integer'Image(Counter));
    Put_Line (Integer'Image(AnagramCounter));
end Passphrase;
