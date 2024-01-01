IFS=","
STUDENT_DB="student_db.csv"
BOOK_DB="book_db.csv"
BORROW_DB="borrow_db.csv"

# Admin details
ADMIN_NAME="Roman"
PASSWORD="roman123"

# Function: Admin_Verify
admin_login() {
    clear
    local message=$1
    local admin_name=""
    local password=""
    local exit=505
    
    echo -e "! Welcome to the Library Management System !"
    echo -e "! Admin Login !\n"
    echo -e "! $message !\n\n"
    
    echo -e "Enter 505 in Admin name to go back\n"
    
    read -p "Enter Admin name: " admin_name
    
    if [ -z $admin_name ]
    then
        admin_login "Admin name cannot be empty"
    elif [ $admin_name == $exit ]
    then
        main
    fi
    
    read -s -p "Enter Admin Password: " password
    
    if [ -z $password ]
    then
        admin_login "Password cannot be empty"
    fi

    if [ $admin_name == $ADMIN_NAME ] && [ $password == $PASSWORD ]
    then
        admin_menu
    else
        admin_login "Invalid admin's name or password"
    fi
}

# Function: Student_Verify
student_login() {
    clear
    local message=$1
    local student_id=""
    local password=""
    local id=""
    local name=""
    local pass=""
    local found=0
    local exit=505
    
    echo -e "! Welcome to the Library Management System !"
    echo -e "! Student Login !\n"
    echo -e "! $message !\n\n"
    
    echo -e "Enter 505 in Student ID to go back\n"
    
    read -p "Enter Student ID:" student_id
    
    if [ -z $student_id ]
    then
        student_login "Student ID cannot be empty"
    elif [ $student_id == $exit ]
    then
        main
    fi
    
    read -s -p "Enter Password:" password
    
    if [ -z $password ]
    then
        student_login "Password cannot be empty"
    fi

    while read id name pass _
    do
        if [ $student_id == $id ] && [ $password == $pass ]
        then
            found=1
            break
        fi
    done < $STUDENT_DB
    
    if [ $found == 1 ]
    then
        student_menu "$id" "$name"
    else
        student_login "Invalid student's ID or password"
    fi
}

# Function: Add_Book
add_book() {
    clear
    local message=$1
    local book_id=""
    local book_name=""
    local book_quantity=""
    local found=0
    local exit=505
    
    echo -e "! Welcome to the Library Management System !"
    echo -e "! Add Book !\n"
    echo -e "! $message !\n\n"
    
    echo -e "Enter 505 in Book ID to go back\n"
    
    read -p "Enter Book ID: " book_id

    if [ -z $book_id ]
    then
        add_book "Book ID cannot be empty"
    elif [ $book_id == $exit ]
    then
        admin_menu
    fi
    
    while read id _ _ _
    do
        if [ $book_id == $id ]
        then
            found=1
            break
        fi
    done < $BOOK_DB
      
    if [ $found == 1 ]
    then
        add_book "Book ID exists"
    else
        read -p "Enter Book Name: " book_name

        if [ -z $book_name ]
        then
            add_book "Book name cannot be empty"
        fi
    
        read -p "Enter Quantity: " book_quantity

        if [ -z $book_quantity ]
        then
            add_book "Quantity cannot be empty"
        fi
    
        echo $book_id,$book_name,$book_quantity,$book_quantity >> $BOOK_DB
        
        add_book "Book $book_name added successfully"
    fi
}

# Function: Borrow_Book
borrow_book(){
    clear
    local message=$1
    local book_id=""
    local choice=""
    local found=0
    local exit=505
    local date=$(date "+%y-%m-%d")
    
    echo -e "! Welcome to the Library Management System !"
    echo -e "! Borrow Book !\n"
    echo -e "! $message !\n\n"
    
    echo -e "Enter 505 in Book ID to go back\n"

    read -p "Enter Book ID to borrow: " book_id
    
    if [ -z $book_id ]
    then
        borrow_book "Book ID cannot be empty"
    elif [ $book_id == $exit ]
    then
        admin_menu
    fi

    while read idB name quantity availability
    do
        if [ $book_id == $idB ]
        then 
            found=1         
            break
        fi
    done < "$BOOK_DB"
        
    if [ $found == 1 ]
    then
        if [ $availability -gt 0 ]
        then
            read -p "Enter Student ID: " student_id
    
            if [ -z $student_id ]
            then
                borrow_book "Student ID cannot be empty"
            fi
        
            while read idS nameS _
            do
                if [ $student_id == $idS ]
                then
                    found=2
                    break
                fi
            done < $STUDENT_DB
    
            if [ $found == 2 ]
            then
                while read idS2 idB2 _
                do
                    if [ $student_id == $idS2 ] && [ $book_id == $idB2 ]
                    then
                        found=3
                        break
                    fi
                done < "$BORROW_DB"
                
                if [ $found == 3 ]
                then
                    borrow_book "Student has already borrowed this book"
                else
                    echo -e "\nBook name: $name"
                    echo -e "\nStudent name: $nameS\n"
                
                    read -p "Do you want to delete? [y/n]: " choice
        
            	    if [ -z $choice ]
                    then
       	                borrow_book  "Choice cannot be empty"
                    elif [ $choice == y ]
                    then
            	        echo $student_id,$book_id,$date >> $BORROW_DB
                        sed -i "s/^$idB,$name,$quantity,$availability/$idB,$name,$quantity,$((availability - 1))/" "$BOOK_DB"
                        borrow_book "Book $name issued successfully to student with ID $student_id"
                    elif [ $choice == n ]
                    then
            	        borrow_book
                    else
            	        borrow_book  "Invalid input"
                    fi
                fi
            else
                borrow_book "Student ID not found"
            fi
        else
            borrow_book "Book is not available"
        fi
    else
        borrow_book "Book ID not found"
    fi
}

# Function: Return_Book
return_book(){
    clear
    local message=$1
    local book_id=""
    local student_id=""
    local choice=""
    local found=0
    local exit=505
    local dateC=$(date "+%y-%m-%d")
    
    echo -e "! Welcome to the Library Management System !"
    echo -e "! Return Book !\n"
    echo -e "! $message !\n\n"
    
    echo -e "Enter 505 in Book ID to go back\n"

    read -p "Enter Book ID to return: " book_id
    
    if [ -z $book_id ]
    then
        return_book "Book ID cannot be empty"
    elif [ $book_id == $exit ]
    then
        admin_menu
    fi
    
    read -p "Enter Student ID: " student_id
    
    if [ -z $student_id ]
    then
        return_book "Student ID cannot be empty" 
    fi
    
    while read idS idB date
    do
        if [ $student_id == $idS ] && [ $book_id == $idB ]
        then
            found=1
            break
        fi
    done < "$BORROW_DB"
    
    if [ $found == 1 ]
    then
        string_dateC=$(date -d "$dateC" "+%s")
	string_date=$(date -d "$date" "+%s")
        
        if [ $string_dateC -gt $string_date ]
        then
            echo -e "\nLast date: $date\n"
            echo "You are late in returning the book"
            read -p "Pay a fine of 50 tk now? (Press 1 to pay, any other key to skip): " choice

            if [ $choice == 1 ]
            then
                while read idB2 name quantity availability
                do
                    if [ $book_id == $idB2 ]
        	    then          
                        break
        	    fi
                done < "$BOOK_DB"
                
                sed -i "/$student_id,$book_id,/d" "$BORROW_DB"
                sed -i "s/^$idB2,$name,$quantity,$availability/$idB2,$name,$quantity,$((availability + 1))/" "$BOOK_DB"
                return_book "Fine paid successfully, Book returned"
            else
                while read idS2 nameS pass due
                do
                    if [ $student_id == $idS2 ]
                    then
                        break
                    fi
                done < $STUDENT_DB
                
                while read idB2 nameB quantity availability
        	do
        	    if [ $book_id == $idB2 ]
        	    then          
                        break
        	    fi
    		done < "$BOOK_DB" 
    		
    		sed -i "/$student_id,$book_id,/d" "$BORROW_DB"
                sed -i "s/^$idS2,$nameS,$pass,$due/$idS2,$nameS,$pass,$((due + 50))/" "$STUDENT_DB"
                sed -i "s/^$idB2,$nameB,$quantity,$availability/$idB2,$nameB,$quantity,$((availability + 1))/" "$BOOK_DB"
                
                return_book "Fine not paid, Book returned"  
            fi
        else
            echo -e "\nLast date: $date\n"
            
            read -p "Do you want to return? [y/n]: " choice
        
            if [ -z $choice ]
            then
       	        return_book  "Choice cannot be empty"
            elif [ $choice == y ]
            then
            	while read idB2 name quantity availability
                do
                    if [ $book_id == $idB2 ]
        	    then          
                        break
        	    fi
                done < "$BOOK_DB"
            
                sed -i "/$student_id,$book_id/d" "$BORROW_DB"
                sed -i "s/^$idB2,$name,$quantity,$availability/$idB2,$name,$quantity,$((availability + 1))/" "$BOOK_DB"
                return_book "Book returned successfully."
            elif [ $choice == n ]
            then
            	admin_menu
            else
            	return_book  "Invalid input"
            fi
        fi
    else
        return_book "No record found for the given student ID and book ID"
    fi
        
}

# Function: Update_Book
update_book() {
    clear
    local message=$1
    local book_id=""
    local book_name=""
    local book_quantity=""
    local choice=""
    local found=0
    local exit=505
    
    echo -e "! Welcome to the Library Management System !"
    echo -e "! Update Book !\n"
    echo -e "! $message !\n\n"
    
    echo -e "Enter 505 in Book ID to go back\n"

    read -p "Enter Book ID to update: " book_id
    
    if [ -z $book_id ]
    then
        update_book "Book ID cannot be empty"
    elif [ $book_id == $exit ]
    then
        admin_menu
    fi

    while read id name quantity availability
    do
        if [ $book_id == $id ]
        then 
            found=1          
            break
        fi
    done < "$BOOK_DB"
    
    if [ $found == 1 ]
    then
        while true
        do
            echo -e "\n1. Update Name"
            echo -e "2. Update Quantity\n"
        
            read -p "Enter your choice: " choice

            case $choice in
                1) echo -e "\nName: $name\n"
                
                   read -p "Enter new Book Name: " book_name
                   
                   if [ -z $book_name ]
                   then
                       update_book "Book name cannot be empty"
                   fi 
                   sed -i "s/^$id,$name,$quantity,$availability/$book_id,$book_name,$quantity,$availability/" "$BOOK_DB"
                   update_book "Book name updated successfully" ;;
                   
                2) echo -e "\nName: $name	Quantity: $quantity\n"
                
                   read -p "Enter new Quantity: " book_quantity
        
                   if [ -z $book_quantity ]
                   then
                       update_book "Quantity cannot be empty"
                   fi
        
                   diff=$((book_quantity - quantity))     

                   sed -i "s/^$id,$name,$quantity,$availability/$book_id,$name,$book_quantity,$((availability + diff))/" "$BOOK_DB"
                   update_book "Book quantity updated successfully" ;;
                   
                *) echo "Invalid choice, Please enter a valid option" ;;
            esac
        done 
    else
        update_book "Book ID not found"
    fi
}

# Function: Delete_Books
delete_book(){
    clear
    local message=$1
    local book_id=""
    local choice=""
    local found=0
    local exit=505
    
    echo -e "! Welcome to the Library Management System !"
    echo -e "! Delete Book !\n"
    echo -e "! $message !\n\n"
    
    echo -e "Enter 505 in Book ID to go back\n"

    read -p "Enter Book ID to delete: " book_id
    
    if [ -z $book_id ]
    then
        delete_book "Book ID cannot be empty"
    
    elif [ $book_id == $exit ]
    then
        admin_menu
    fi
    
    while read id name _ _
    do
        if [ $book_id == $id ]
        then
            found=1         
            break
        fi
    done < "$BOOK_DB"
        
    if [ $found == 1 ]
    then
        while read _ idB _
        do
            if [ $book_id == $idB ]
            then
                found=2
                break
            fi
        done < "$BORROW_DB"
    
        if [ $found == 2 ]
        then
            delete_book "All books are not returned"
        else
            echo -e "\nName: $name\n"
                
            read -p "Do you want to delete? [y/n]: " choice
        
            if [ -z $choice ]
            then
       	        delete_book  "Choice cannot be empty"
            elif [ $choice == y ]
            then
            	sed -i "/\b$book_id\b/d" "$BOOK_DB"
                delete_book "Book details deleted successfully"
            elif [ $choice == n ]
            then
            	delete_book
            else
            	delete_book  "Invalid input"
            fi
        fi   
    else
        delete_book "Book ID not found"
    fi
}

# Function: View_Books
view_books() {
    clear
    local user_id=$1
    local user_name=$2
    local message=$3
    local choice=""
    local exit=505
    
    echo -e "! Welcome to the Library Management System !"
    echo -e "! View Books !\n"
    echo -e "! $message !\n\n"
    
    echo "Book ID | Title | Quantity | Available"
    echo "--------------------------------------"
    awk -F "," 'BEGIN {OFS=" | "} {printf "%-10s|%-10s|%-10s|%-10s\n", $1, $2, $3, $4}' "$BOOK_DB"
    
    echo ""
    
    read -p "Enter 505 to go back: " choice
    
    if [ -z $choice ]
    then
        view_books "$user_id" "$user_name" "Cannot be empty"
    elif [ $choice == $exit ]
    then
        if [ $user_id == $ADMIN_NAME ]
        then
            admin_menu
        else
            student_menu "$user_id" "$user_name"
        fi
    else
        view_books "$user_id" "$user_name" "Invalid input"
    fi
}

# Function: Borrowed_Books
view_borrowed_books() {
    clear
    local user_id=$1
    local user_name=$2
    local message=$3

    echo -e "! Welcome to the Library Management System !"
    echo -e "! View Borrowed Books !\n"
    echo -e "! $message !\n\n"

    echo "Student ID | Book ID | Return Date"

    echo "--------------------------------"

    if [ "$user_id" == "$ADMIN_NAME" ]
    then
        awk -F "," 'BEGIN {OFS=" | "} {printf "%-11s|%-10s|%-15s\n", $1, $2, $3}' "$BORROW_DB"
    else
        awk -F "," -v id="$user_id" 'BEGIN {OFS=" | "} $1==id {printf "%-11s|%-10s|%-15s\n", $1, $2, $3}' "$BORROW_DB"
    fi

    echo ""
    
    read -p "Enter 505 to go back: " choice
    
    if [ -z $choice ]
    then
        view_borrowed_books "$user_id" "$user_name" "Cannot be empty"
    elif [ $choice == $exit ]
    then
        if [ $user_id == $ADMIN_NAME ]
        then
            admin_menu
        else
            student_menu "$user_id" "$user_name"
        fi
    else
        view_borrowed_books "$user_id" "$user_name" "Invalid input"
    fi
}

# Function: Add_Student
add_student() {
    clear
    local message=$1
    local student_name=""
    local student_id=""
    local password=""
    local due=0
    local found=0
    local exit=505
    
    echo -e "! Welcome to the Library Management System !"
    echo -e "! Add Student !\n"
    echo -e "! $message !\n\n"
    
    echo -e "Enter 505 in Student ID to go back\n"
    
    read -p "Enter Student ID: " student_id

    if [ -z $student_id ]
    then
        add_student "Student ID cannot be empty"
    
    elif [ $student_id == $exit ]
    then   
        admin_menu
    fi
    
    while read id _ _
    do
        if [ $student_id == $id ]
        then
            found=1
            break
        fi
    done < $STUDENT_DB

    if [ $found == 1 ]
    then
        add_student "Student ID exists"
    else
        read -p "Enter Student Name: " student_name

        if [ -z $student_name ]; then
            add_student "Student name cannot be empty"
        fi
    
        read -p "Enter Student Password: " password

        if [ -z $password ]; then
            add_student "Student password cannot be empty"
        fi

        echo $student_id,$student_name,$password,$due >> $STUDENT_DB
        
        add_student "Student $student_name added successfully"
    fi
}

# Function: Update_Student
update_student(){
clear
    local user_id=$1
    local user_name=$2
    local message=$3
    local student_id=""
    local student_name=""
    local password=""
    local old_pass=""
    local payment=""
    local choice=""
    local found=0
    local exit=505
    
    echo -e "! Welcome to the Library Management System !"
    echo -e "! Update Student !\n"
    echo -e "! $message !\n\n"
    
    echo -e "Enter 505 in Student ID to go back\n"

    read -p "Enter Student ID to update: " student_id
    
    if [ -z $student_id ]
    then
        update_student "$user_id" "$user_name" "Student ID cannot be empty"
    elif [ $student_id == $exit ]
    then
        if [ $user_id == $ADMIN_NAME ]
        then
            admin_menu
        else
            student_menu "$user_id" "$user_name"
        fi
    fi

    while read id name pass _
    do
        if [ $student_id == $id ]
        then 
            found=1         
            break
        fi
    done < "$STUDENT_DB"
     
    if [ $found == 1 ]
    then
        while true
        do
            echo -e "\n1. Update Name"
            echo -e "2. Update Password\n"
        
            read -p "Enter your choice: " choice

            case $choice in
                1) echo -e "\nName: $name\n"
                
                   read -p "Enter new Student Name: " student_name
                   
                   if [ -z $student_name ]
                   then
                       update_student "$user_id" "$user_name" "Student name cannot be empty"
                   fi
                   
                   if [ $user_id == $ADMIN_NAME ]
                   then
                       sed -i "s/^$id,$name,$pass,$due/$student_id,$student_name,$pass,$due/" "$STUDENT_DB"
                       update_student "$user_id" "$user_name" "Student name updated successfully"
                   else
                       read -p "Enter Password: " old_pass
                       
                       if [ -z old_pass ]
                       then
                           update_student "$user_id" "$user_name" "Password cannot be empty"
                       fi
                       
                       if [ $old_pass == $pass ]
                       then
                           sed -i "s/^$id,$name,$pass,$due/$student_id,$student_name,$pass,$due/" "$STUDENT_DB"
                           update_student "$user_id" "$user_name" "Student name updated successfully"
                       else
                           update_student "$user_id" "$user_name" "Wrong Password"
                       fi
                   fi ;;
 
                2) echo -e "\nName: $name\n"
                
                   read -p "Enter new Password: " password
        
                   if [ -z password ]
                   then
                       update_student "$user_id" "$user_name" "Password cannot be empty"
                   fi
                   
                   if [ $user_id == $ADMIN_NAME ]
                   then
                       sed -i "s/^$id,$name,$pass,$due/$student_id,$name,$password,$due/" "$STUDENT_DB"
                       update_student "$user_id" "$user_name" "Password updated successfully"
                   else
                       read -p "Enter old Password: " old_pass
                       
                       if [ -z old_pass ]
                       then
                           update_student "$user_id" "$user_name" "Password cannot be empty"
                       fi
                       
                       if [ $old_pass == $pass ]
                       then
                           sed -i "s/^$id,$name,$pass,$due/$student_id,$name,$password,$due/" "$STUDENT_DB"
                           update_student "$user_id" "$user_name" "Password updated successfully"
                       else
                           update_student "$user_id" "$user_name" "Wrong Password"
                       fi
                   fi ;;     
                      
                *) echo "Invalid choice, Please enter a valid option" ;;
            esac
        done 
    else
        update_student "$user_id" "$user_name" "Student ID not found"
    fi
}

# Function: Delete_Books
delete_student(){
    clear
    local message=$1
    local student_id=""
    local found=0
    local choice=""
    local exit=505
    
    echo -e "! Welcome to the Library Management System !"
    echo -e "! Delete Student !\n"
    echo -e "! $message !\n\n"
    
    echo -e "Enter 505 in Student ID to go back\n"

    read -p "Enter Student ID to delete: " student_id
    
    if [ -z $student_id ]
    then
        delete_student "Student ID cannot be empty"
    elif [ $student_id == $exit ]
    then
        admin_menu
    fi
    
    while read id name _ due
    do
        if [ $student_id == $id ]
        then
            found=1          
            break
        fi
    done < "$STUDENT_DB"
        
    if [ $found == 1 ]
    then
        if [ $due -gt 0 ]
        then
            delete_student "Student payment is pending"
        else
            while read idS _ _
            do
                if [ $student_id == $idS ]
                then
                    found=2
                    break
                fi
            done < "$BORROW_DB"
    
            if [ $found == 2 ]
            then
                delete_student "All books are not returned"
            else
                echo -e "\nName: $name\n"
                
                read -p "Do you want to delete? [y/n]: " choice
        
                if [ -z $choice ]
        	then
            	    delete_student  "Choice cannot be empty"
        	elif [ $choice == y ]
        	then
            	    sed -i "/\b$student_id\b/d" "$STUDENT_DB"
                    delete_student "Student details deleted successfully"
        	elif [ $choice == n ]
        	then
            	    delete_student
        	else
            	    delete_student  "Invalid input"
        	fi
            fi
        fi   
    else
        delete_student "Student ID not found"
    fi
}

# Function: View_Student
view_students() {
    clear
    local message=$1
    local choice=""
    local exit=505
    
    echo -e "! Welcome to the Library Management System !"
    echo -e "! View Students !\n"
    echo -e "! $message !\n\n"

    echo "Student ID | Name | Due"

    echo "--------------------------------------"

    awk -F "," 'BEGIN {OFS=" | "} {printf "%-10s|%-12s|%-10s\n", $1, $2, $4}' "$STUDENT_DB"
    
    echo ""
    
    read -p "Enter 505 to go back: " choice

    if [ -z $choice ]
    then
        view_students "Cannot be empty"
    elif [ $choice == $exit ]
    then
        admin_menu
    else
        view_students "Invalid input"
    fi
}

# Function: Make_Payment
make_payment(){
    clear
    local message=$1
    local student_id=""
    local payment=""
    local found=0
    local exit=505
    
    echo -e "! Welcome to the Library Management System !"
    echo -e "! Make Payment !\n"
    echo -e "! $message !\n\n"
    
    echo -e "Enter 505 in Student ID to go back\n"

    read -p "Enter Student ID to add payment: " student_id
    
    if [ -z $student_id ]
    then
        make_payment "Student ID cannot be empty"
    elif [ $student_id == $exit ]
    then
        admin_menu
    fi

    while read id name pass due
    do
        if [ $student_id == $id ]
        then 
            found=1          
            break
        fi
    done < "$STUDENT_DB"
    
    if [ $found == 1 ]
    then
        if [ $due -gt 0 ]
        then
            echo -e "\nName: $name	Due: $due \n"
            read -p "Enter the Amount to pay: " payment
        
            if [ -z payment ]
            then
                make_payment "Payment cannot be empty"
            fi   

            sed -i "s/^$id,$name,$pass,$due/$student_id,$name,$pass,$(( due - payment ))/" "$STUDENT_DB"
            make_payment "Payment of $payment Tk successfully processed"
        else
            make_payment "No dues for this ID"
        fi
    else
        make_payment "Student ID not found"
    fi     
}


# Function: Admin_Menu
admin_menu() {
    clear
    local message=$1
    local choice=""
    
    echo -e "! Welcome to the Library Management System !"
    echo -e "! Admin Menu !\n"
    echo -e "! $message !\n"
    
    while true
    do
    echo -e "Welcome, $ADMIN_NAME\n"
    echo "1. Add Book"
    echo "2. Add Student"
    echo "3. View Books"
    echo "4. View Students"
    echo "5. Borrow Book"
    echo "6. Return Book"
    echo "7. View Borrowed Books"
    echo "8. Update Book Details"
    echo "9. Update Student Details"
    echo "10. Delete Book"
    echo "11. Delete Student"
    echo "12. Make Payment"
    echo -e "13. Logout\n"

    read -p "Enter your choice: " choice

    case $choice in
        1) add_book ;;
        2) add_student ;;
        3) view_books "$ADMIN_NAME" ;;
        4) view_students ;;
        5) borrow_book ;;
        6) return_book ;;
	7) view_borrowed_books "$ADMIN_NAME" ;;
        8) update_book ;;
        9) update_student "$ADMIN_NAME" ;;
        10) delete_book ;;
        11) delete_student ;;
        12) make_payment ;;
        13) main ;;
        *) admin_menu "Invalid choice, Please enter a valid option" ;;
    esac
done
}

# Function: Student_Menu
student_menu() {
    clear
    local student_id=$1
    local student_name=$2
    local message=$3
    local choice=""
    
    echo -e "! Welcome to the Library Management System !"
    echo -e "! Student Menu !\n"
    echo -e "! $message !\n"

    while true
    do
        echo -e "Welcome, $student_name\n"
        echo "1. View Books"
        echo "2. View Borrowed Books"
        echo "3. Update Student Details"
        echo -e "4. Logout\n"
        
        read -p "Enter your choice: " choice

        case $choice in
            1) view_books "$student_id" "$student_name" ;;
            2) view_borrowed_books "$student_id" "$student_name";;
            3) update_student "$student_id" "$student_name" ;;
            4) main ;;
            *) student_menu "$student_id" "$student_name" "Invalid choice, Please enter a valid option" ;;
        esac
    done
}

main() {
    clear
    local message=$1
    local user_type=""
    
    echo -e "! Welcome to the Library Management System !\n"
    echo -e "! $message !\n"

    while true
    do
        echo "1. Admin"
        echo "2. Student"
        echo -e "3. Exit\n"
        
        read -p "Choose User Type: " user_type

        case $user_type in
	    1) admin_login ;;
	    2) student_login ;;
	    3) exit ;;
	    *) main "Invalid Choice, Please enter a valid option";;
        esac
    done
}

# Main
clear
main
