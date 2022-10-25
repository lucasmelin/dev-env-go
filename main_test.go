package main

import "testing"

func TestEcho(t *testing.T) {
	cases := []struct {
		name    string
		args    []string
		wantErr bool
	}{
		{name: "happy path", args: []string{"binary", "hello", "world"}, wantErr: false},
		{name: "missing args", args: []string{}, wantErr: true},
	}
	for _, tc := range cases {
		t.Run(tc.name, func(t *testing.T) {
			err := echo(tc.args)
			if (err != nil) != tc.wantErr {
				t.Fatalf("unexpected error: %s", err)
			}
		})
	}
}
