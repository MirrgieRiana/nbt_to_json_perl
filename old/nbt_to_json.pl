use strict;
use warnings;
use utf8;
use Encode;
use Data::Dumper;
use JSON qw/encode_json decode_json/;

binmode STDIN;

#

sub read_data($) {
	my $size = shift;
	if ($size == 0) {
		return "";
	} else {

		my $buffer;
		my $result = read(STDIN, $buffer, $size);

		if ($result == 0) {
			return undef;
		}
		if (! defined $result) {
			return undef;
		}

		return $buffer;
	}
}

sub read_byte() {
	return unpack("c", read_data(1));
}

sub read_short() {
	return unpack("s>", read_data(2));
}

sub read_int() {
	return unpack("l>", read_data(4));
}

sub read_long() {
	return unpack("q>", read_data(8));
}

sub read_float() {
	return unpack("f", read_data(4));
}

sub read_double() {
	return unpack("d", read_data(8));
}

sub read_byte_array() {
	my $length = read_int();
	my @values = map {
		read_byte();
	} 0 .. $length - 1;

	return \@values;
}

sub read_string() {
	my $length = read_short();
	my $data = read_data($length);
	return decode("utf8", $data);
}

sub read_list() {
	my $type = read_byte();
	my $length = read_int();
	my @values = map {
		read_payload($type);
	} 0 .. $length - 1;

	return {
		type => $type,
		values => \@values,
	};
}

sub read_compound() {
	my @entries;
	while (1) {
		my $entry = read_entry();
		if ($entry->{type} == 0) {
			last;
		}
		push @entries, $entry;
	}
	return \@entries;
}

sub read_entry() {
	my $type = read_byte();
	if ($type == 0) {
		return {
			type => $type,
		};
	}
	my $key = read_string();
	my $value = read_payload($type);

	return {
		type => $type,
		key => $key,
		value => $value,
	};
}

sub read_int_array() {
	my $length = read_int();
	my @values = map {
		read_int();
	} 0 .. $length - 1;

	return \@values;
}

sub read_long_array() {
	my $length = read_int();
	my @values = map {
		read_long();
	} 0 .. $length - 1;

	return \@values;
}

sub read_payload($) {
	my $type = shift;
	if ($type == 1) {
		return read_byte();
	} elsif ($type == 2) {
		return read_short();
	} elsif ($type == 3) {
		return read_int();
	} elsif ($type == 4) {
		return read_long();
	} elsif ($type == 5) {
		return read_float();
	} elsif ($type == 6) {
		return read_double();
	} elsif ($type == 7) {
		return read_byte_array();
	} elsif ($type == 8) {
		return read_string();
	} elsif ($type == 9) {
		return read_list();
	} elsif ($type == 10) {
		return read_compound();
	} elsif ($type == 11) {
		return read_int_array();
	} elsif ($type == 12) {
		return read_long_array();
	} else {
		die "Unknown Type: $type";
	}
}

#

print JSON->new->canonical->ascii->encode(read_entry()), "\n";
