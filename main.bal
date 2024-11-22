import ballerina/io;
import ballerina/sql;
import ballerinax/aws.redshift;
import ballerinax/aws.redshift.driver as _;

configurable string jdbcUrl = ?;
configurable string user = ?;
configurable string password = ?;

redshift:Client redshift = check new (jdbcUrl, user, password);

type User record {|
    string name;
    string email;
    string state;
|};

public function main() returns error? {

    sql:ParameterizedQuery sqlQuery = `SELECT * FROM Users limit 10`;
    stream<User, error?> resultStream = redshift->query(sqlQuery);
    check from User user in resultStream
        do {
            io:println("Full details of users: ", user);
        };
}
