#!/usr/bin/perl

use strict;
# 'strict' pragma enforces strict variable declaration rules, helping catch potential errors.

use warnings;
# 'warnings' pragma enables warnings output, helping catch potential issues like syntax errors.

use Term::ANSIColor;
# Imports the 'Term::ANSIColor' module, which allows for colored text output in the terminal.

# Defines a subroutine to print a separator line across the width of the terminal.
sub print_separator {
    # Prints '-' character multiplied by the width of the terminal, then a newline.
    print '-' x `tput cols`, "\n";
}

# Defines a subroutine to print a header at the start of the program.
sub print_header {
    # First, print a separator line.
    print_separator();
    # Print a colored header message in blue.
    print colored("        Welcome to Package Manager        ", 'blue'), "\n";
    # Print another separator line below the header.
    print_separator();
}

# Defines a subroutine to display the main menu options to the user.
sub print_menu {
    # Print instructions to the user.
    print "Please select an option:\n";
    # Print each menu option in green for better visibility.
    print colored("1.", 'green'), " Update the package database and upgrade all packages.\n";
    print colored("2.", 'green'), " Remove a package and its dependencies.\n";
    print colored("3.", 'green'), " Clean the package cache.\n";
    print colored("4.", 'green'), " Clean up orphaned packages.\n";
    print colored("5.", 'green'), " Check the dependencies of a package.\n";
}

# Defines a subroutine to handle checking the dependencies of a specific package.
sub check_package_dependencies {
    # Prompt the user to enter the name of a package.
    print "Enter the package name to check its dependencies: ";
    # Remove the newline character from the input and assign it to $package_name.
    chomp(my $package_name = <STDIN>);
    # Print a message indicating that dependencies are being checked, in yellow for visibility.
    print colored("Checking dependencies for $package_name...", 'yellow'), "\n";
    # Execute a system command to list the dependencies of the specified package using pacman.
    system("pacman -Qi $package_name | grep Depends");
}

# Defines a subroutine to execute an option based on user input.
sub execute_option {
    # The user's choice is passed as an argument to the subroutine.
    my $choice = shift;

    # A series of if-else statements to handle each menu option.
    if ($choice == 1) {
        print colored("Updating package database and upgrading all packages...", 'yellow'), "\n";
        system("trizen -Syu");
    } elsif ($choice == 2) {
        print colored("Removing a package and its dependencies...", 'yellow'), "\n";
        print "Enter the package name you want to remove: ";
        chomp(my $package_name = <STDIN>);
        system("sudo pacman -Rns $package_name");
    } elsif ($choice == 3) {
        print colored("Cleaning the package cache...", 'yellow'), "\n";
        system("sudo pacman -Sc");
    } elsif ($choice == 4) {
        print colored("Cleaning up orphaned packages...", 'yellow'), "\n";
        system("sudo pacman -Rns \$(pacman -Qtdq)");
    } elsif ($choice == 5) {
        check_package_dependencies();
    } else {
        # If an invalid option is selected, print an error message and exit.
        print colored("Invalid option selected. Exiting.", 'red'), "\n";
        exit 1;
    }
}

# Defines the main subroutine that orchestrates the program's flow.
sub main {
    # Print the header.
    print_header();
    # Display the main menu.
    print_menu();
    # Prompt the user for their choice and remove the newline from their input.
    print "Enter your choice (1/2/3/4/5): ";
    chomp(my $choice = <STDIN>);
    # Execute the option chosen by the user.
    execute_option($choice);
    # Print a completion message in green.
    print colored("Operation completed.", 'green'), "\n";
}

# Calls the 'main' subroutine to start the program.
main();
