#!/bin/bash

VBoxManage controlvm "workstation" poweroff
VBoxManage controlvm "bastion" poweroff
VBoxManage controlvm "servera" poweroff
VBoxManage controlvm "serverb" poweroff
VBoxManage controlvm "serverc" poweroff
VBoxManage controlvm "serverd" poweroff
VBoxManage controlvm "servere" poweroff
