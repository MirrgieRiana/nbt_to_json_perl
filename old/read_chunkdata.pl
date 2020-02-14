use strict;

my $filename = shift @ARGV;
die unless defined $filename;

my $x = shift @ARGV;
die unless defined $x;

my $z = shift @ARGV;
die unless defined $z;

#

open my $fh, "<", $filename;
binmode $fh;

sub read_data($) {
	my $length = shift;
	return "" if $length == 0;
	my $data;
	read $fh, $data, $length or die;
	return $data;
}

sub read_byte() {
	return unpack "c", read_data(1);
}

sub read_int() {
	return unpack "l>", read_data(4);
}

#

my $index = $x + $z * 32;
#print STDERR "index: ", $index, "\n";

seek $fh, $index * 4, 0;

my $offset = read_int();
#print STDERR "offset: ", $offset, "\n";

my $sector_index = $offset >> 8;
#print STDERR "sector_index: ", $sector_index, "\n";

my $sector_length = $offset & 255;
#print STDERR "sector_length: ", $sector_length, "\n";

seek $fh, $sector_index * 4096, 0;
#print STDERR "seek: ", $sector_index * 4096, "\n";

my $length = read_int();
#print STDERR "length: ", $length, "\n";

my $format = read_byte();
#print STDERR "format: ", $format, "\n";

print read_data($length - 1);
