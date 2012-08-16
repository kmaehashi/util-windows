# "NETDOM JOIN %COMPUTERNAME%" for Windows 7
# @author Kenichi Maehashi
# @version 2010-03-21

Param([String] $Domain, [String] $UserD, [String] $PasswordD, [Int32] $REBoot)
Set-PSDebug -Strict

function Const([String] $name, $value) {Set-Variable -name $name -value $value -scope script -option Constant}
function Usage() {
@"
The syntax of this command is:

NETDOM-JOIN -Domain:domain [-UserD:user] [-PasswordD:password] [-REBoot:Time in seconds]

NETDOM-JOIN joins this computer to the domain.

-Domain         Specifies the domain which the machine should join

-UserD          User account used to make the connection with the domain
                specified by the -Domain argument

-PasswordD      Password of the user account specified by -UserD

-REBoot         Specifies that the machine should be shutdown and automatically
                rebooted after the Join has completed.  The number of seconds
                before automatic shutdown must also be provided
"@
}

Const JOIN_DOMAIN 1
Const ACCT_CREATE 2
Const ACCT_DELETE 4
Const WIN9X_UPGRADE 16
Const DOMAIN_JOIN_IF_JOINED 32
Const JOIN_UNSECURE 64
Const MACHINE_PASSWORD_PASSED 128
Const DEFERRED_SPN_SET 256
Const INSTALL_INVOCATION 262144

if ($Domain -eq "") {
	Usage
	Exit
}

$result =
	(Get-WmiObject Win32_ComputerSystem).JoinDomainOrWorkgroup(
		$Domain,
		$PasswordD, 
		$Domain + "\" + $UserD,
		$null,
		$JOIN_DOMAIN + $ACCT_CREATE
	)

if ($result.ReturnValue -eq 0) {
	Start-Sleep $REBoot
	Restart-Computer
} else {
	"Failed to join this computer to the domain!"
	$result
}
