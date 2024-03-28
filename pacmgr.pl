#!/usr/bin/perl

use strict;
use warnings;
use Term::ANSIColor;

sub print_separator {
    print '-' x `tput cols`, "\n";
}

sub print_header {
    print_separator();
    print colored("        Welcome to Package Manager        ", 'blue'), "\n";
    print_separator();
}

sub print_menu {
    print "Please select an option:\n";
    print colored("1.", 'green'), " Update the package database and upgrade all packages.\n";
    print colored("2.", 'green'), " Remove a package and its dependencies.\n";
    print colored("3.", 'green'), " Clean the package cache.\n";
    print colored("4.", 'green'), " Clean up orphaned packages.\n";
    print colored("5.", 'green'), " Check the dependencies of a package.\n";
}

sub check_package_dependencies {
    print "Enter the package name to check its dependencies: ";
    chomp(my $package_name = <STDIN>);
    print colored("Checking dependencies for $package_name...", 'yellow'), "\n";
    system("pacman -Qi $package_name | grep Depends");
}

sub execute_option {
    my $choice = shift;

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
        print colored("Invalid option selected. Exiting.", 'red'), "\n";
        exit 1;
    }
}

sub main {
    print_header();
    print_menu();
    print "Enter your choice (1/2/3/4/5): ";
    chomp(my $choice = <STDIN>);
    execute_option($choice);
    print colored("Operation completed.", 'green'), "\n";
}

# Call the main function
main();
