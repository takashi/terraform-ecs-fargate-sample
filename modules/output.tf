output "subnet" {
  value = "${
        map(
            "nat_ids", "${join(",", aws_subnet.nat.*.id)}",
            "public_idsids", "${join(",", aws_subnet.public.*.id)}",
        )
    }"
}
