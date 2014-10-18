/* 
	Test Program!  
*/ 
import java.util.*; 
class code{
	public static void main(String[] args){
		String first, last;
		int age; 
		Scanner scanner; 
		scanner = new Scanner(System.in);

		System.out.print("Enter your first name please");
		first = scanner.next();
		System.out.print("Enter your last name please");
		last = scanner.next();

		System.out.println("");
		System.out.println("Your first name is " + first + ".");
		System.out.println("Your last name is " + last + "."); 
		System.out.println("");
		System.out.println("Nice to meet you, " + first + 
					" " + last + ".");
	}
}
