import { Controller, Post, Body, Get } from '@nestjs/common';
import { UserService } from './user.service';
import { User } from './user.entity';

@Controller('users')
export class UserController {
  constructor(private readonly userService: UserService) {}

  @Post('signup')
  async signUp(@Body()user : User): Promise<User> {
     return this.userService.createUser(user);    
  }

  @Post('update_infos')
  async updateInfos(@Body()user : User): Promise<User> {
    console.log('updateinfos: '+ user.idPatient);
    return this.userService.updateInfos(user);    
 }
 
 @Post('update_password')
 async updatePassword(@Body() body: { idPatient: number, oldPassword : string, newPassword : string}): Promise<void> {
  const { idPatient, oldPassword ,newPassword} = body;
  await this.userService.updatePassword(idPatient,oldPassword, newPassword);    
}
   
  @Post('user')
  async getpatientbyid(@Body('id_patient') id_patient:number){
    console.log('getpateintbyid : '+ id_patient);
    return this.userService.getuserbyid(id_patient);
  }

  @Get('getusers')
  async getallusers(){
    return this.userService.getallusers();
  }

  @Post('delete')
  async deleteuser(@Body('id_patient') id_patient:number){
    return this.userService.deleteuser(id_patient)
  }

}
